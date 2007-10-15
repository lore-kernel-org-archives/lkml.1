Return-Path: <linux-kernel-owner+w=401wt.eu-S934913AbXJOSqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934913AbXJOSqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934154AbXJOShW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:37:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44586 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262AbXJOShU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:37:20 -0400
Subject: Re: [build bug] error: 'VID_HARDWARE_GEMTEK' undeclared
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, pexu@kapsi.fi,
       Douglas Schilling Landgraf <dougsland@gmail.com>
In-Reply-To: <Pine.LNX.4.58.0710151117260.15624@shell4.speakeasy.net>
References: <20071015111345.GA26777@elte.hu>
	 <Pine.LNX.4.58.0710151117260.15624@shell4.speakeasy.net>
Content-Type: text/plain; charset=utf-8
Date: Mon, 15 Oct 2007 16:37:00 -0200
Message-Id: <1192473420.5240.139.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Em Seg, 2007-10-15 às 11:27 -0700, Trent Piepho escreveu:
> On Mon, 15 Oct 2007, Ingo Molnar wrote:
> > randconfig testing of latest -git found this build bug:
> >
> > drivers/media/radio/radio-gemtek.c:557: error: 'VID_HARDWARE_GEMTEK' undeclared here (not in a function)
> >
> > config attached.
> 
> Problem:
> # CONFIG_VIDEO_V4L1_COMPAT is not set
> 
> The VID_HARDWARE_* defines are only created if that is turned on.  gemtek
> should depend on VIDEO_V4L1_COMPAT.
> 
> *or*
> 
> As far as I can tell, these VID_HARDWARE defines are entirely useless.  I
> couldn't find any instance of them being used for anything other than setting
> the .hardware field of struct video_device, and I was unable to find any
> instance of that field being used.
> 
> It looks like the whole thing is just unused cruft.  Mauro, would it be ok if
> I made a patch to just delete the whole mess?

Those VID_HARDWARE_* are bogus. No place checks for the .hardware value.
I've already made a patch removing it. Feel free to double check it.

-- 
Cheers,
Mauro

