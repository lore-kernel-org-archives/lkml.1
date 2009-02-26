Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbZBZWZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbZBZWZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbZBZWYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:24:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757340AbZBZWYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:24:54 -0500
Date: Thu, 26 Feb 2009 14:24:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: john stultz <johnstul@us.ibm.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902261413400.3111@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6F39F.9040801@krogh.cc>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com> 
 <49A70B24.6090706@krogh.cc> <1235685269.6811.11.camel@localhost.localdomain> <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Feb 2009, Thomas Gleixner wrote:
> 
> Is the delta anything NTP might get upset about:
> 
> 2.6.26: time.c: Detected 2311.847 MHz processor.
> 2.6.29: Detected 2310.029 MHz processor.
> 
> If yes, then we need to fix NTP not the calibration code :)

Well, that _is_ about 500ppm difference, and we claim that we _should_ 
have reached 150ppm with the 15ms delay. We clearly don't seem to have 
done that. I'm not quite sure why - we _should_ be finding the edge of the 
PIT events to within roughly a microsecond (assuming that's about as long 
as an "inb" takes), and that should give us a pretty good fast 
calibration, but maybe I'm overlooking something.

Or - and this may be more likely - there are chipsets that aren't very 
good at reading the PIT in a tight loop. That may explain why it's a 
problem on Jesper's hardware, but we haven't gotten tons of reports of 
this from others.

I see that it's a SunFire X2200, which I think uses an nVidia HT 
southbridge. I assume it's an nForce4 thing. There shouldn't be anything 
odd there, and the PIT read shouldn't be taking any longer than on 
anything else, but who knows? 

		Linus
