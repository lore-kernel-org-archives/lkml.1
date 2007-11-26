Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbXKZI34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbXKZI34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 03:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbXKZI3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 03:29:47 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:41194 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbXKZI3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:29:46 -0500
From: Wagner Ferenc <wferi@niif.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: bonding sysfs output
References: <87tznafjeu.fsf@szonett.ki.iif.hu>
	<20071125205150.4e49915f.akpm@linux-foundation.org>
Date: Mon, 26 Nov 2007 09:29:40 +0100
In-Reply-To: <20071125205150.4e49915f.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sun, 25 Nov 2007 20:51:50 -0800")
Message-ID: <87lk8lflzf.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sun, 25 Nov 2007 16:12:57 +0100 Wagner Ferenc <wferi@niif.hu> wrote:
>
>> I propose it as a fix for trailing NULs and spaces like eg.
>> 
>> $ od -c /sys/class/net/bond0/bonding/slaves 
>> 0000000   e   t   h   -   l   e   f   t       e   t   h   -   r   i   g
>> 0000020   h   t      \n  \0
>> 0000025
>> 
>> I'm afraid there're other problems with "++more++" handling, but let's
>> not consider those just yet.  Find the patch attached.  The first
>> hunks also renames buffer to buf, for consistency's shake.
>> 
>> The original version had varying behaviour for Not Applicable cases.
>> This patch also settles for empty files (not even a line feed) in
>> those cases, but I'm not sure about the general policy on this matter.
>
> hm, there are a lot of changes there.  Were they all actually needed to fix
> the one bug which you have described?

Trailing NULs are present in each file under /sys/class/net/*/bonding
and also in /sys/class/net/bonding_masters.  That is, in every file
provided by drivers/net/bonding/bond_sysfs.c.  Most of the patch is
concerned with this.

Closely related is the presence of trailing spaces in multivalue
files.  There are three such files, one of them has the trailing space
removed.  This patch removes it from the other two.  During this it
also renames one function argument 'buffer' to 'buf', for consistency.

On the policy side: some files are not applicable to some types of
bonds, and return a single linefeed in that case.  Except for one
single case, which returns 'NA\n'.  The patch changes these cases into
emtpy files.

If these are worthy changes, I'm absolutely willing to split up the
patch into three parts as the above.
-- 
Thanks,
Feri.
