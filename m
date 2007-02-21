Return-Path: <linux-kernel-owner+w=401wt.eu-S1750918AbXBUXkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918AbXBUXkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXBUXkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:40:41 -0500
Received: from nz-out-0506.google.com ([64.233.162.238]:9586 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXBUXkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:40:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tAvFXWCt+KZR9yHbLCN7j6xAV0E0+j611DhrII+dMwEFY3fsfzY80nV6Hr8pkC8KV16yFCa00rd6w+OYe3Pm11IFgaPLw4zlTxu7dcigIk9ZG/klSW3MMdA4Da8ZzoFPU+1BCUHhio8r3md+LzoYSCZREDLTLeI56a/AAHJB2BI=
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>, Luca Tettamanti <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <cb7bb73a0702061508x767882dcia1b13f85d898b6e7@mail.gmail.com>
References: <ephv35$4i3$1@sea.gmane.org>
	 <20070128160831.fb51347f.akpm@osdl.org>
	 <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
	 <20070128162907.370f5476.akpm@osdl.org>
	 <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
	 <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com>
	 <20070130203301.GA15067@dreamland.darkstar.lan>
	 <20070204201713.GA12867@dreamland.darkstar.lan>
	 <Pine.LNX.4.64.0702062034380.9224@pentafluge.infradead.org>
	 <cb7bb73a0702061508x767882dcia1b13f85d898b6e7@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 07:43:26 +0800
Message-Id: <1172101406.4217.16.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 00:08 +0100, Giuseppe Bilotta wrote: 
> On 2/6/07, James Simmons <jsimmons@infradead.org> wrote:
> >
> > If you can find post the manufacturer and model number we can place it on
> > the backlist in fbmon. Also we should figure out what is wrong and fix it.
> 
> It's the UltraSharp UXGA display that used to come with Dell Inspiron
> 8200, 15" with a resolution of 1600x1200. I've been looking all around
> for more info on it, but the only things I could find were posts that
> remarked the problems Windows nVidia drivers have with some of these
> (no image when running at 1600x1200), and other posts about banded
> gradients with Windows drivers on Radeon video cards (but I get banded
> gradients also win my nVidia card, on Linux, regardless of which
> driver I use, binary, nv or nouveau).
> 
> As mentioned in another post in this thread, I can't get any info out
> of the i2c busses, because even when I have them available (i.e. after
> loading nvidiafb) I get XXXX all around (on all three of them).
> Suggestions on how to get the information welcome.

Is this the same monitor you posted here?

http://marc.theaimsgroup.com/?l=linux-kernel&m=112807065616218&w=2

If yes, we already have the manufacturer and model code. The main
problem is that the EDID of this display has no sync range (H: 75-75kHz
and V: 60-60Hz).  Extending Hsync from 30-75kHz as a fix to the EDID
block shouldn't be too hard.

I already have a patch for this which I forgot to send to you
before :-).  If you can confirm that this is still the same hardware,
I'll send you a test patch

Tony

