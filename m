Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZEWNHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZEWNHg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 09:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZEWNH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 09:07:26 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:57301 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZEWNHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 09:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O1Bc3SMCBn7By9/B7Dw34cPerEBnu/5fuVqmtitJql4loutFccSH8msHVIcHlQOZpx
         WnkxpXxh6lGrptjiuBQdjSx5wfm1AUbnZcOGJMoKEYs9WJ+73j+HErIrewIJsr5QrF6Y
         tHbFuEGyMaKiv8l8KDOS8Mbt/rrt/2PB2cj5o=
Date: Sat, 23 May 2009 17:07:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rakib Mullick <rakib.mullick@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86,APIC: Detect lapic_is_integrated() once - use on
	and on.
Message-ID: <20090523130724.GA7872@lenovo>
References: <b9df5fa10905220631y7b1a094dn9a6e13de1b9c43af@mail.gmail.com> <20090522200239.GD5354@lenovo> <4A170713.402@zytor.com> <alpine.LFD.1.10.0905222309180.19449@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0905222309180.19449@ftp.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Fri, May 22, 2009 at 11:18:14PM +0100]
| On Fri, 22 May 2009, H. Peter Anvin wrote:
| 
| > > actually this change could be dangerous. I don't
| > > remember if I saw mixed configuration at all but
| > > I would not be that sure that we will never met it.
| 
|  It is a matter of question whether this change gives any performance 
| benefit, but certainly it is not dangerous.  What's the difference in code 
| generated?

About mixing conf -- I thought about integrated apic which behave like
discrete one, not physical mixing of devices which is hard to implement
due to differ bus used (though hw engineers do strange things sometime :)

| 
|  Also APIC accesses cannot be cached, so access to the variable if hot in 
| the cache should be faster, but OTOH if cold, then main RAM access may 
| actually be slower as the APIC is quite closely coupled to the CPU.  Have 
| any figures indicating performance change been obtained?
|

Good point! Though if I'm not missing something the only hot site
is lapic timer since other routines are called either as a part
of bootstrapping or suspend/resume.

| 
| > That seems unlikely in the extreme.  To the best of my knowledge, only
| > 486s ever used the external APICs.
| 
|  Several Pentium-based systems used external APICs (both ones built around 
| original P5 and ones using P54C chips), but mixed configurations were not 
| possible because of ICC bus/protocol incompatibility.  First of all the 
| number of lines was different (5 vs 3)...
| 
|   Maciej
| 

	-- Cyrill
