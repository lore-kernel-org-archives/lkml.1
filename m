Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbZD0IyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbZD0IyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZD0Ixx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:53:53 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:50931 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZD0Ixw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QIKRc4UBUhmXXlzFFExUHzn8pZKLH6R/SkciNPwoaiJ7/fFkUJhRm3767oxm/Lv9AK
         Z5P8vgFt6dj4Lvg1ssKnglhvGp4k3D8iaspQy/PXdvSef+19ZhZBOtOOKBko6d5y7adU
         eQD/+khDMh6ZkfLdUM4xinPZGX0uLxC211SiA=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904270129350.26825@chino.kir.corp.google.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com>
	 <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com>
	 <alpine.DEB.2.00.0904241155550.26080@chino.kir.corp.google.com>
	 <40a4ed590904241216u655300ddvaa4660e11ad2cffc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241224001.28589@chino.kir.corp.google.com>
	 <40a4ed590904250132o63e715cbvaccf5aac82265cd@mail.gmail.com>
	 <alpine.DEB.2.00.0904261252010.18988@chino.kir.corp.google.com>
	 <40a4ed590904262333k13dd3630t8d241eb30782bbab@mail.gmail.com>
	 <alpine.DEB.2.00.0904270129350.26825@chino.kir.corp.google.com>
Date: Mon, 27 Apr 2009 10:53:51 +0200
Message-ID: <40a4ed590904270153q306e80f2v62499434c64d92a6@mail.gmail.com>
Subject: Re: Kernel 2.6.29 runs out of memory and hangs.
From: Zeno Davatz <zdavatz@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Hannes Wyss <hwyss@ywesee.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David

On Mon, Apr 27, 2009 at 10:32 AM, David Rientjes <rientjes@google.com> wrote:

> All allowable zones have minimum watermarks that define how much memory
> an oom killed task may use so that it can quickly exit.  This is the
> purpose of the TIF_MEMDIE flag in the kernel.

Thanks for the info.

> The policy is better defined in userspace to determine what memory-hogging
> task should be killed in low memory situations.  Users can already tune
> the /proc/pid/oom_adj score of any task so that the oom killer can prefer
> it over other tasks (see Documentation/filesystems/proc.txt).  For low
> memory situations, however, userspace can act in any number of ways to
> prevent reaching an oom condition.

This may be off-Topic, but: Can I assign a PID to a process at
startup? Say Apache always should have PID 2755, or Ruby should always
have PID 1003. Otherwise how would I set the score for a PID at
Kernel-Boop-Up?

> Once the oom condition has been reached, however, the oom killer must act
> to free some memory, otherwise the kernel usually livelocks.

Interesting. In our case we did not have a score for Apache in

/proc/pid/oom_adj

that must have caused the livelock because oom_kill could not kill the
biggest task (Apache) in full.

Best
Zeno
