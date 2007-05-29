Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbXE2O0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbXE2O0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXE2O0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:26:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56401 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbXE2O0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:26:07 -0400
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Thierry Merle <thierry.merle@free.fr>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <465BBAFB.30906@free.fr>
References: <2172422218943432279@wsc.cz>
	 <1180364420.21547.160.camel@localhost>
	 <d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>
	 <1180378677.21547.189.camel@localhost>
	 <d9def9db0705281217t514462e1wef412de7a9c81826@mail.gmail.com>
	 <1180383071.21547.230.camel@localhost> <465B49EB.4080204@free.fr>
	 <465BBAFB.30906@free.fr>
Content-Type: text/plain
Date: Tue, 29 May 2007 11:25:12 -0300
Message-Id: <1180448712.21547.314.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  
> > Hi Mauro and Markus,
> > Just to summ up what I understood we need:
> >
> > What do we need in userspace, only for v4l (dvb is not concerned):
> > - colorspace translations
> > - filters that be done in hardware if the selected hardware can, 
> > otherwise software plugin
> > - decompression algorithm like stk11xx or usbvision (the decompression 
> > algorithm is in kernelspace since it is of linear complexity but shall 
> > be moved to userspace)

Yes. The first focus, IMO, should be the last one.

> > Using pwlib will not mean that application developers will use pwlib 
> > to decode v4l driver outputs.
> > C bindings are much more popular than C++ bindings and do not prevent 
> > object oriented design.

IMO, we should implement very simple and efficient C subroutines.

> > Application developers implement their own codecs.

They can do it if they want. However, if we have a very consistent and
easy to use subroutines for those weird decompress stuff, it is likely
that they will use it.

> > As an example, every application do deinterlacing internally or not...
> > Application developers will probably not use pwlib v4l extensions 
> > because they will prefer to write adapted codecs for their framework.

I think we shouldn't deal with deinterlacing. the API should be as
simple as possible, focusing on implementing some stuff highly linked
with the hardware (like specific decompression stuff, proprietary
colospace conversions, etc).
> >
> > Much more important for me is to see the actual specification of the 
> > needed v4l extensions points, with advice/participation of 
> > application/codec developers.
> As an example, we could empacket frames with a header containing 
> audio/video format as it is done for MPEG streams.
> Is it possible without breaking the current ABI?

Yes, it is possible. In fact, some devices currently work by generating
a common audio and video stream. The driver may just send the packet
as-is, leaving to the userspace API the function to de-merge and
synchronize audio and video.

> Do application developers would cope with that?

Maybe.
 
Cheers,
Mauro

