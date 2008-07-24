Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYGXPBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYGXPBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYGXPBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:01:38 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:20789 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbYGXPBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eZqiWAXq56XfwRDle5BjctSSg55p3e5C/Tj9kJErCFlc6eK0cDPkL9HTT9FcqFd2Dy
         AM9mrO/cE6PYnS4Rt4AMmfDDHqVYc6hj5siEte1zzV2Q+V7DbpYvGmddjRqDaxX1WDqr
         QpWm36xM0krGniRPO9HkER1qM8Arhk5ZgMJSM=
Date: Thu, 24 Jul 2008 19:01:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe
Message-ID: <20080724150116.GC32422@lenovo>
References: <48885DDC.9010003@fujitsu-siemens.com> <20080724111631.GA3432@lenovo> <48886E6D.1030005@fujitsu-siemens.com> <20080724120512.GA21804@lenovo> <488889B6.9070707@fujitsu-siemens.com> <20080724143151.GA32422@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724143151.GA32422@lenovo>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Thu, Jul 24, 2008 at 06:31:51PM +0400]
| [Martin Wilck - Thu, Jul 24, 2008 at 03:55:02PM +0200]
| > Cyrill Gorcunov wrote:
| >
| >> yes, it will issue some effects but it's better then stuck there.
| >> More over in 'case of SMI flood with current patch you don't get
| >> error message printed i think so you better add max iteration
| >> counter so user will see on console (or whatever) that he is got
| >> problems.
| >>                 - Cyrill -
| >
| > I disagree. If you have a system that generates SMIs in this extreme  
| > frequency, you're better off stuck than running on such an unstable  
| > system. The user _will_ see messages on the console if this happens.  
| > Note that apparently there are few people who have trouble with this. We  
| > did see problems, but never had more than 1 SMI disturbing the  
| > calibration procedure.
| >
| > Anyway, here is another patch that defines max iteration counts. I  
| > haven't added a "Signed-off:" line, because I prefer the original 
| > version.
| >
| > Martin
| >
| 
| yes, Martin, it'll be written on console (just forgot it's not interrupt
| driven). I've Cc'ed Maciej in previous message so we should better wait
| for his opinion I think. For me the almost ideal solution could be like -
| lets user to choose what he wants. I mean you even could add some boot
| param to specify behaviour on a such case like panic on SMI flood during
| calibration. yes - if we got smi flood we have serious troubles anyway but
| i don't think that being just stuck is good choise. And that is why I do like
| much more _this_ patch. Anyway - thanks!
| 
| 		- Cyrill -

btw, Martin, don't get me wrong please - i'm not just complaining :)
The changes you propose is important enough _but_ it could introduce
regression. Look, with situation of miscalibrated apic timer kernel
was working before but with the patch it could stop to work. So if
user has a such screwed motherboard he could be shocked if it stop
booting with message about SMI happened. we defenitely have to provide
some workaround for this. And your max iteration counter solution
would be fine I think.

		- Cyrill -
