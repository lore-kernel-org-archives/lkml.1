Return-Path: <linux-kernel-owner+w=401wt.eu-S932962AbXGROUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbXGROUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757760AbXGROUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:20:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:59453 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbXGROUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nzLBr6bWBxryF/ViaAhekDB6s/1bOluDf08yRIRcpr5ttooVQICcqKuzCysqfzZRobjGWjrLijJcmwKl74OG7fGH3+U1z3kqkRIIVnjqBe2yx0sOG7Ls1b879hG7B3TzJn0hZ+SaKdarAnEmVdr2ksU7sK1SX/z10x91sGnAzQw=
Subject: Re: VESAFB CUSTOM RESOLUTION
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200707181645.01097.a1426z@gawab.com>
References: <200707181342.00647.a1426z@gawab.com>
	 <1184760917.4523.13.camel@daplas>  <200707181645.01097.a1426z@gawab.com>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 22:20:26 +0800
Message-Id: <1184768426.4523.20.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 16:45 +0300, Al Boldi wrote:
> Antonino A. Daplas wrote:
> > On Wed, 2007-07-18 at 13:42 +0300, Al Boldi wrote:
> > > Geert Uytterhoeven wrote:
> > > > On Wed, 18 Jul 2007, Sasa Ostrouska wrote:
> > >
> > > Is there any technical reason why vesafb shouldn't support non-BIOS
> > > modes?
> >
> > vesafb can only use modes included by the vendor in the card's BIOS. The
> > mode table contains standard modes defined by VESA, and perhaps
> > vendor-defined custom modes. However, the mode ID of custom modes varies
> > from card to card, so you have to 'probe' the BIOS first for the list of
> > modes and their associated ID.  X + the 'vesa' driver does that probe,
> > and so does the lrmi tool vbetest.
> >
> > So, one cannot just set any mode, unless that mode is already defined in
> > the BIOS mode table. In VBE 3.0, you might be able to choose an
> > arbitrary vertical refresh rate, but that's the best mode tuning you can
> > do with the video BIOS.
> 
> Thanks for a great explanation!
> 
> Looks like this chip supports VBE 3.0, but it only locks into 60Hz refresh.  
> Here is an excerpt; full log attached.
> 
> 

What you need to look at the X log is this particular part (this is the
output of my card, and for the sake of brevity, I removed the
descriptive sections):

Mode: 100 (640x400)
Mode: 101 (640x480)
Mode: 102 (800x600)
Mode: 103 (800x600)
Mode: 104 (1024x768)
Mode: 105 (1024x768)
Mode: 106 (1280x1024)
Mode: 107 (1280x1024)
*Mode: 10e (320x200)
Mode: 10f (320x200)
*Mode: 111 (640x480)
Mode: 112 (640x480)
*Mode: 114 (800x600)
Mode: 115 (800x600)
*Mode: 117 (1024x768)
Mode: 118 (1024x768)
Mode: 11a (1280x1024)
Mode: 11b (1280x1024)
Mode: 130 (320x200)
Mode: 131 (320x400)
*Mode: 132 (320x400)
Mode: 133 (320x400)
Mode: 134 (320x240)
*Mode: 135 (320x240)
Mode: 136 (320x240)
*Mode: 13d (640x400)
Mode: 13e (640x400)
Mode: 145 (1600x1200)
Mode: 146 (1600x1200)
Mode: 147 (1400x1050)
Mode: 148 (1400x1050)
Mode: 152 (2048x1536)

The list of modes include standard VESA modes and custom modes such as
2048x1536.  So, if I want to use this mode for vesafb, I will add
vga=0x352 (0x152 + 0x200) to my boot line.

Tony

