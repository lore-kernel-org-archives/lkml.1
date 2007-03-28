Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbXC1V21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbXC1V21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXC1V20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:28:26 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:28483 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbXC1V2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:28:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=PyFF59k9kEpC7RC9Has3OU422FMmEo2xtMg+q6tNI+DB5TN2dyuMWyXRsEkpfBjGyfemT8Y8iB96eZPKnBiEqk88Oaf8Fc5VETlEbg3seu+3bcxNscTveWOL9z2DL8pVZmZ/YmA+FKtNp1IELjDup6SGYRpwvyf2hQlKoBpoXb8=
From: Maxim <maximlevitsky@gmail.com>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [3/6] 2.6.21-rc4: known regressions
Date: Wed, 28 Mar 2007 23:27:55 +0200
User-Agent: KMail/1.9.6
Cc: linux-pm@lists.linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>, linux-ide@vger.kernel.org,
       gregkh@suse.de, linux-pm@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, linux-acpi@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, jgarzik@pobox.com,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703282220.00199.maximlevitsky@gmail.com> <200703281359.29009.david-b@pacbell.net>
In-Reply-To: <200703281359.29009.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703282327.56132.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 22:59:26 David Brownell wrote:
> On Wednesday 28 March 2007 1:19 pm, Maxim wrote:
> > On Wednesday 28 March 2007 21:38:55 David Brownell wrote:
> 
> > > 
> > > Also, making HPET use the legacy mode seems like a step backwards.
> 
> > 	It is not 'legacy' mode,
> > It is a legacy replacement mode.
> 
> Typo, sorry.
> 
> 
> > It this mode HPET takes over IRQ0 and IRQ 8 and provides this way
> > replacement for PIT and RTC periodic function 
> 
> It's that RTC periodic thing that bothers me, I don't mind about
> the PIT.  Remember that IRQ8 is also used for other RTC functions.
> 
> Now, if there were a way to tell rtc-cmos that HPET is active,
> and arrange some kind of handshake ... that would be different.
> 
> - Dave
> 

Yes,
	When HPET is active it eats RTC IRQ,
	So the only way out is to emulate RTC using HPET,
	It is done this way in old rtc driver, rtc-cmos should do the same.

	Of course suspend resume is not supported at all by old rtc driver

	I already wrote complete support for suspend/resume for old rtc driver (I wrote it long time ago)

	Now I fixed it to support HPET , and this way I discovered that HPET doesn't have suspend resume functions

	I will do last checks now and send this patch very soon

	I am also planning to add support of HPET and suspend/resume for rtc-cmos, but I didn't start this yet.

	Best regards,
		Maxim Levitsky




	
