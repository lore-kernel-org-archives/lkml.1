Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbXEPHmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbXEPHmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbXEPHmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 03:42:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:12410 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbXEPHmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 03:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JR8cGi93gLCs6nT/xTtHmHtNSclW8wov9nSUas1Yb0WMLbER8CZo50XGIk19jbnFFOLYUIGjWhGQiFAPQyWxAuETyFREDiuFh8SqmNbjn1bcnEX6QJbG6B+IOeMKsFoXsSD5d7TMYUwhVgfZAz1UGn8MPeI0rbLAJQYCD1zNtIs=
Message-ID: <38b2ab8a0705160042o350d429ct72c43749ff6bcbb8@mail.gmail.com>
Date: Wed, 16 May 2007 09:42:02 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: clockevent questions
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1179267014.12838.38.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0705120754l281f54eevd1e91e2f01fff6f2@mail.gmail.com>
	 <1178982892.22481.183.camel@localhost.localdomain>
	 <38b2ab8a0705121313k37be467cy55402b490101ac9c@mail.gmail.com>
	 <1179001391.22481.216.camel@localhost.localdomain>
	 <38b2ab8a0705150147s4ce72914qfa30d543ed8a4839@mail.gmail.com>
	 <1179267014.12838.38.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 5/16/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> Francis,
>
> On Tue, 2007-05-15 at 10:47 +0200, Francis Moreau wrote:
> > My question is about the clock resolution field which is equal to 1ns.
> > How is this possible since my timer's frequency is only 100Mhz ?
>
> you are right. It is a bit strange. The resolution info is not really
> reflecting the clock event source capability. I look if there is a sane
> solution for that.
>

Doesn't that make hrtimer_get_res() and its callers buggy since they
return this 1ns value which is not reflecting the correct clock event
capability ?

Another question about the output of '/proc/timer_list':

[...]
active timers:
 #0: <c03fde10>, tick_sched_timer, S:01
 # expires at 64696546875000 nsecs [in 2514469 nsecs]
 .expires_next   : 64696546875000 nsecs
[...]

Doesn't the 2 expire time lines give the same information ? If so,
couldn't we merge them into : ".expires_next   : 64696546875000 nsecs
[in 2514469 nsecs]" ?

Thanks
-- 
Francis
