Return-Path: <linux-kernel-owner+w=401wt.eu-S1764839AbXE2Td0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764839AbXE2Td0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761334AbXE2Tcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:32:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46508 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761131AbXE2Tcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:32:54 -0400
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Thierry Merle <thierry.merle@free.fr>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <465C7920.2080203@free.fr>
References: <2172422218943432279@wsc.cz>
	 <1180364420.21547.160.camel@localhost>
	 <d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>
	 <1180378677.21547.189.camel@localhost>
	 <d9def9db0705281217t514462e1wef412de7a9c81826@mail.gmail.com>
	 <1180383071.21547.230.camel@localhost> <465B49EB.4080204@free.fr>
	 <465BBAFB.30906@free.fr> <1180448712.21547.314.camel@localhost>
	 <465C7920.2080203@free.fr>
Content-Type: text/plain; charset=utf-8
Date: Tue, 29 May 2007 16:31:56 -0300
Message-Id: <1180467116.9509.73.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Ter, 2007-05-29 às 21:04 +0200, Thierry Merle escreveu:
> 
> Mauro Carvalho Chehab a écrit :
> >   
> >   
> >>> Hi Mauro and Markus,
> >>> Just to summ up what I understood we need:
> >>>
> >>> What do we need in userspace, only for v4l (dvb is not concerned):
> >>> - colorspace translations
> >>> - filters that be done in hardware if the selected hardware can, 
> >>> otherwise software plugin
> >>> - decompression algorithm like stk11xx or usbvision (the decompression 
> >>> algorithm is in kernelspace since it is of linear complexity but shall 
> >>> be moved to userspace)
> >>>       
> >
> > Yes. The first focus, IMO, should be the last one.
> >
> >   
> 
> OK, so we must open the V4L2 API to add a custom pixel format.
I don't think we need to change the API. The API already exports the
format, as a fourcc-like info. We just need to add newer codes as
they'll be added into kernel.

> While brainstorming, I thought it would be funny to create userspace 
> drivers like FUSE based projects do.
> Applications would see nothing but a new device driver to access, all 
> decompression algorithm would be in userspace.
> The path from the application to the v4l2 kernel driver:
> [Application]<->[/mnt/video0 (created by FUSE-like userspace 
> lib)]<->[/dev/video0 (created by kernel v4l2 driver)]
> There are limitations that I don't know, but this would be transparent 
> for the applications.

This seems to be an interesting approach.

> > Yes, it is possible. In fact, some devices currently work by generating
> > a common audio and video stream. The driver may just send the packet
> > as-is, leaving to the userspace API the function to de-merge and
> > synchronize audio and video.
> >   
> So we have a userspace lib that will demux/uncompress device driver output.
> This lib will know each device driver particularities to know how to 
> demux/uncompress in a a/v format that will be understood by the application.

Yes. However, we should try to do loose coupling whenever possible, to
keep maintainership of the "library"(*) as simple as possible.

(*) With this approach, it seems that it will turn into a helper daemon,
instead of just a library.

Cheers,
Mauro

