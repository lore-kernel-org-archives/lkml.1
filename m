Return-Path: <linux-kernel-owner+w=401wt.eu-S1763604AbYDVNKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763604AbYDVNKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763465AbYDVNKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:10:25 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:18189 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760307AbYDVNKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=im5fp9lhSOfK2qNGCjNWZUs6UbIHOXs8xLpuwRB4SiQxvu7l6c7xZUPOhn23soPIcvUDHcUCr9kt4PX+9nErHrpWL32+KDi/5YCEoCJRfUO5r6BPgxWjoEFylENRIajkiS9SSUySL1Jooafe0JeRMnR56rXAdKL7Xh+Q5uoDxgc=
Message-ID: <480DE3B3.6050702@gmail.com>
Date: Tue, 22 Apr 2008 22:10:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       oliver@neukum.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       zaitcev@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] klist: implement KLIST_INIT() and DEFINE_KLIST()
References: <480DB6A4.20101@gmail.com> <1208869049.7115.254.camel@twins>	 <480DE215.2070803@gmail.com> <1208869591.7115.263.camel@twins>
In-Reply-To: <1208869591.7115.263.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>> These locks don't nest so being in the same class should be okay and I 
>> was following what (at least some of) other __SPIN_LOCK_UNLOCKED users 
>> are doing.  If putting these locks into separate classes is the RTTD, sure.
> 
> Ah, they'll actually be in seprate classes all of the same name. So I
> think it is cleaner to cause them to have separate names too.
> 
> see look_up_lock_class() in kernel/lockdep.c:
> 
>         /*
>          * Static locks do not have their class-keys yet - for them the key
>          * is the lock object itself:
>          */
>         if (unlikely(!lock->key))
>                 lock->key = (void *)lock;

Ah.. I'll put change it to name.  Thanks.

-- 
tejun
