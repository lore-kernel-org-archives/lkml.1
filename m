Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbXLUHrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbXLUHrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbXLUHrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:47:35 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:32013
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934AbXLUHre convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:47:34 -0500
Message-Id: <476B7DBB.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 21 Dec 2007 07:47:55 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] constify tables in kernel/sysctl_check.c
References: <476A73A3.76E4.0078.0@novell.com><476A73A3.76E4.0078.0@novell.com> (Jan
 Beulich's message of "Thu,20 Dec 2007 12:52:35 +0000")
 <m1y7bp6k7b.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1y7bp6k7b.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Eric W. Biederman <ebiederm@xmission.com> 21.12.07 00:05 >>>
>"Jan Beulich" <jbeulich@novell.com> writes:
>
>> Remains the question whether it is intended that many, perhaps even
>> large, tables are compiled in without ever having a chance to get used,
>> i.e. whether there shouldn't #ifdef CONFIG_xxx get added.
>
>
>The constification looks good.  The file should be compiled only when
>we have sysctl support.  We use those tables when we call 
>register_sysctl_table.  Which we do a lot.

I understand this. Nevertheless, the tables take 23k on 64-bits, and many
of them are unused when certain subsystems aren't being built (and some
are even architecture specific). The arlan tables are a particularly good
example, but the netfilter ones are pretty big and probably not always
used, too.

Jan

