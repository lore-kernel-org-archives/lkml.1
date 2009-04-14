Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZDNWUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZDNWUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZDNWUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:20:30 -0400
Received: from mx7.orcon.net.nz ([219.88.242.57]:47054 "EHLO mx7.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbZDNWU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:20:29 -0400
X-Greylist: delayed 3026 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2009 18:20:29 EDT
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       dri-devel@lists.sourceforge.net, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>,
       Oliver Falk <oliver@linux-kernel.at>, glisse@freedesktop.org
Message-Id: <1CAA6FF2-8C1C-4E6D-812A-5677E8313539@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Matt Turner <mattst88@gmail.com>
In-Reply-To: <b4198de60904141315x14d898e5x89fc334dd977b7a1@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: Radeon kernel-modesetting on Alpha. Problem reading PCI ROM
Date: Wed, 15 Apr 2009 09:29:59 +1200
References: <b4198de60904141315x14d898e5x89fc334dd977b7a1@mail.gmail.com>
X-Mailer: Apple Mail (2.930.3)
X-DSPAM-Check: by mx7.orcon.net.nz on Wed, 15 Apr 2009 09:30:00 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Apr 15 09:30:01 2009
X-DSPAM-Confidence: 0.7003
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt

> Jerome and I think that the hang may be caused by being unable to read
> the PCI ROM.

I have been taking a little bit of a look at reading the PCI ROM on a  
radeon video card to try to get the radeonhd xserver video driver  
going on Alpha.  On one of my Alphas the SRM can't post the card so  
xserver/radeonhd have to do all the dirty work.  I discovered that the  
r[567]xx radeon cards need quite a bit of setting up to enable the PCI  
ROM.  In short, writing to the enable and rom files in the PCI card's  
sysfs directory in the prescribed manner isn't sufficient to enable  
the ROM.

I wrote a patch to the rhd_dump and rhd_conntest utils of the radeonhd  
project, so that they would use libpciaccess to access the registers  
and PCI ROM of the radeon r[567]xx cards.  Unfortunately my patches  
got mangled in posting to the radeonhd list, and I have been  
travelling for the last couple of weeks, so they didn't make the  
release of radeonhd last week.

The upshot is that I can read the PCI ROM of a Radeon HD2400 card with  
my patches applied to rhd_conntest, and I have had Xserver 1.5.3 up  
and running with the HD2400 card on a PWS600au.

I can send you the patches to rhd_dump and rhd_conntest if you would  
like to try them out.

Cheers
Michael.

