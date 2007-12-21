Return-Path: <linux-kernel-owner+w=401wt.eu-S1762006AbXLUNeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006AbXLUNeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 08:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbXLUNeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 08:34:09 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40908 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbXLUNeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:34:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] constify tables in kernel/sysctl_check.c
References: <476A73A3.76E4.0078.0@novell.com>
	<476A73A3.76E4.0078.0@novell.com>
	<m1y7bp6k7b.fsf@ebiederm.dsl.xmission.com>
	<476B7DBB.76E4.0078.0@novell.com>
Date: Fri, 21 Dec 2007 06:33:46 -0700
In-Reply-To: <476B7DBB.76E4.0078.0@novell.com> (Jan Beulich's message of "Fri,
	21 Dec 2007 07:47:55 +0000")
Message-ID: <m1zlw45g05.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jan Beulich" <jbeulich@novell.com> writes:

>>>> Eric W. Biederman <ebiederm@xmission.com> 21.12.07 00:05 >>>
>>"Jan Beulich" <jbeulich@novell.com> writes:
>>
>>> Remains the question whether it is intended that many, perhaps even
>>> large, tables are compiled in without ever having a chance to get used,
>>> i.e. whether there shouldn't #ifdef CONFIG_xxx get added.
>>
>>
>>The constification looks good.  The file should be compiled only when
>>we have sysctl support.  We use those tables when we call 
>>register_sysctl_table.  Which we do a lot.
>
> I understand this. Nevertheless, the tables take 23k on 64-bits, and many
> of them are unused when certain subsystems aren't being built (and some
> are even architecture specific). The arlan tables are a particularly good
> example, but the netfilter ones are pretty big and probably not always
> used, too.

The size isn't my favorite thing.  But given how much of a mess sysctl_check.c
has allowed me to clean up and get a handle on I'm not inclined to do
anything that would compromise the checking.

Probably the sanest way to remove table entries is to individually remove and
deprecate parts of the binary sys_sysctl interface so that we don't need the
table entries.

Maybe we could through in a few #ifdefs and #defines so we can reduce
the set of allowed sysctl entries even more base on config options.

I'm not volunteering to do more then is absolutely necessary to keep
sys_sysctl working and correct until we reach a point where everyone
can agree that users of the interface truly have had fair warning and
then I intend to delete all of the code that deals with the binary
sysctl interface.

Eric
