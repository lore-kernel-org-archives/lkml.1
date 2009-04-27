Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZD0IdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZD0IdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZD0IdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:33:06 -0400
Received: from smtp-out.google.com ([216.239.33.17]:11144 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZD0IdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:33:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Uf6domJXl2+KL9v/OAxIPRBClMEBwYE8JWa0CX6VdWacBl75Fece7OwHpsvOhopcI
	VsQJ66CVtDemt32cu6fyw==
Date: Mon, 27 Apr 2009 01:32:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zeno Davatz <zdavatz@gmail.com>
cc: linux-kernel@vger.kernel.org, Hannes Wyss <hwyss@ywesee.com>
Subject: Re: Kernel 2.6.29 runs out of memory and hangs.
In-Reply-To: <40a4ed590904262333k13dd3630t8d241eb30782bbab@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0904270129350.26825@chino.kir.corp.google.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com> <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com> <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com> <alpine.DEB.2.00.0904241155550.26080@chino.kir.corp.google.com>
 <40a4ed590904241216u655300ddvaa4660e11ad2cffc@mail.gmail.com> <alpine.DEB.2.00.0904241224001.28589@chino.kir.corp.google.com> <40a4ed590904250132o63e715cbvaccf5aac82265cd@mail.gmail.com> <alpine.DEB.2.00.0904261252010.18988@chino.kir.corp.google.com>
 <40a4ed590904262333k13dd3630t8d241eb30782bbab@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Zeno Davatz wrote:

> Can you recommend a link where I can read up on this issue / problem?
> It seems to me when the system is already out of memory it does not
> have enough "memory" for freeing itself for some fresh memory,
> specially if there is one application, that uses about 99% of the
> memory. I would suggest, that in such a case it should just kill the
> task that uses the most memory.
> 

All allowable zones have minimum watermarks that define how much memory 
an oom killed task may use so that it can quickly exit.  This is the 
purpose of the TIF_MEMDIE flag in the kernel.

> This sounds very interesting. Would this be working together with
> udev? How would it got about to kill a task like "Apache" or "Ruby" or
> any other application that is running on the linux machine.
> 

The policy is better defined in userspace to determine what memory-hogging 
task should be killed in low memory situations.  Users can already tune 
the /proc/pid/oom_adj score of any task so that the oom killer can prefer 
it over other tasks (see Documentation/filesystems/proc.txt).  For low 
memory situations, however, userspace can act in any number of ways to 
prevent reaching an oom condition.

Once the oom condition has been reached, however, the oom killer must act 
to free some memory, otherwise the kernel usually livelocks.
