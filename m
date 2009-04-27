Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZD0MDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZD0MDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZD0MDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:03:42 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38050 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbZD0MDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qTtUJsN8+7DbYvbI52J7CFV/OTGGn/LcYvNAFtk0bHkQdtZwua3X1SnWhrVEHJHomI
         4rvpmBWR7aioRvMp626vIu16nIjYcC5Sf67AWBpn9XRb02HOZaatl4OfHOWkAAcvVOao
         gTTbbTK31stc864i48xtQeR9/euhFu3u2eoFA=
MIME-Version: 1.0
In-Reply-To: <40a4ed590904270153q306e80f2v62499434c64d92a6@mail.gmail.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com>
	 <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com>
	 <alpine.DEB.2.00.0904241155550.26080@chino.kir.corp.google.com>
	 <40a4ed590904241216u655300ddvaa4660e11ad2cffc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241224001.28589@chino.kir.corp.google.com>
	 <40a4ed590904250132o63e715cbvaccf5aac82265cd@mail.gmail.com>
	 <alpine.DEB.2.00.0904261252010.18988@chino.kir.corp.google.com>
	 <40a4ed590904262333k13dd3630t8d241eb30782bbab@mail.gmail.com>
	 <alpine.DEB.2.00.0904270129350.26825@chino.kir.corp.google.com>
	 <40a4ed590904270153q306e80f2v62499434c64d92a6@mail.gmail.com>
Date: Mon, 27 Apr 2009 14:03:39 +0200
Message-ID: <40a4ed590904270503j5d485d66r53b4dbc63622edbb@mail.gmail.com>
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

Thanks for all your help and input. It was very helpful ans useful.

On Mon, Apr 27, 2009 at 10:53 AM, Zeno Davatz <zdavatz@gmail.com> wrote:
> On Mon, Apr 27, 2009 at 10:32 AM, David Rientjes <rientjes@google.com> wrote:
>
>> All allowable zones have minimum watermarks that define how much memory
>> an oom killed task may use so that it can quickly exit.  This is the
>> purpose of the TIF_MEMDIE flag in the kernel.
>
> Thanks for the info.
>
>> The policy is better defined in userspace to determine what memory-hogging
>> task should be killed in low memory situations.  Users can already tune
>> the /proc/pid/oom_adj score of any task so that the oom killer can prefer
>> it over other tasks (see Documentation/filesystems/proc.txt).  For low
>> memory situations, however, userspace can act in any number of ways to
>> prevent reaching an oom condition.
>
> This may be off-Topic, but: Can I assign a PID to a process at
> startup? Say Apache always should have PID 2755, or Ruby should always
> have PID 1003. Otherwise how would I set the score for a PID at
> Kernel-Boop-Up?

Ok, we solved this issue, with the following commit:

http://scm.ywesee.com/?p=oddb.org;a=blobdiff;f=bin/oddbd;h=655b4c235594159d3fe4290696ecc54580188c7c;hp=9cb744b4affe30beee935a495223015d9ce090ce;hb=6d38f6839f746bcf2dc701528e343170af8f47be;hpb=a8b4f8c43200a0035df9f5002a5ea9ec8133e99e

Best
Zeno
