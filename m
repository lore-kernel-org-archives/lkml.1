Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbZLVMGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbZLVMGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 07:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZLVMGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 07:06:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36044 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZLVMGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 07:06:07 -0500
To: Jiri Olsa <jolsa@redhat.com>
Cc: jbaron@redhat.com, mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] dynamic debug - adding ring buffer storage support
From: Andi Kleen <andi@firstfloor.org>
References: <1261481526-17630-1-git-send-email-jolsa@redhat.com>
Date: Tue, 22 Dec 2009 13:06:06 +0100
In-Reply-To: <1261481526-17630-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's message of "Tue, 22 Dec 2009 12:32:06 +0100")
Message-ID: <87ws0fcixd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> writes:

> Hi,
>
> as I use dynamic debug sometimes, I thought it could be useful having
> the possibility to store the output somewhere else than dmesg.
>
> The attached patch implements support for storing dynamic debug
> messages to the ring buffer.
>
> The dynamic debug allows simple addition of new flags,
> so I added 'r' flag for ring buffer storage.
>
> I used the ring buffer implementation from trace framework.
>
> hopefuly this could be any use for others as well...
> plz let me know what you think,

The basic idea sounds good, but doing it all inline is a horrible 
idea. That will bloat the kernel considerably because all
users have to expand this code.

I would suggest to implement an out of line dyndebug_printk()
which does all of this out of line.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
