Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbZFEWRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbZFEWRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZFEWRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:17:05 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38299 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZFEWRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:17:03 -0400
Date: Sat, 6 Jun 2009 00:19:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: dubious section mismatch test (was Re: [PULL] soc-camera: one commit as v4l2-dev preparation)
Message-ID: <20090605221920.GL29008@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0905071841331.9460@axis700.grange> <20090509062726.22d18182@pedra.chehab.org> <Pine.LNX.4.64.0905091430100.3515@axis700.grange> <20090509165416.GA25534@uranus.ravnborg.org> <Pine.LNX.4.64.0905092113280.10748@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905092113280.10748@axis700.grange>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 08:33:03PM +0200, Guennadi Liakhovetski wrote:
> On Sat, 9 May 2009, Sam Ravnborg wrote:
> 
> > On Sat, May 09, 2009 at 06:13:13PM +0200, Guennadi Liakhovetski wrote:
> > > On Sat, 9 May 2009, Mauro Carvalho Chehab wrote:
> > > 
> > > > WARNING: /home/v4l/master/v4l/soc_camera.o(.data+0x0): Section mismatch in reference from the variable soc_camera_pdrv to the function .devinit.text:soc_camera_pdrv_probe()
> > > > The variable soc_camera_pdrv references
> > > > the function __devinit soc_camera_pdrv_probe()
> > > > If the reference is valid then annotate the
> > > > variable with __init* (see linux/init.h) or name the variable:
> > > > *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 
> > > > 
> > > > WARNING: /home/v4l/master/v4l/soc_camera.o(.data+0x8): Section mismatch in reference from the variable soc_camera_pdrv to the function .devexit.text:soc_camera_pdrv_remove()
> > > > The variable soc_camera_pdrv references
> > > > the function __devexit soc_camera_pdrv_remove()
> > > > If the reference is valid then annotate the
> > > > variable with __exit* (see linux/init.h) or name the variable:
> > > > *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 
> > > 
> > > FWIW, I find this test dubious. Matching on symbol names doesn't seem like 
> > > a good idea to me. Can we introduce a new marker instead something like
> > > 
> > > static struct whatever_driver __driver driver = {
> > > 	.probe	= my_probe,
> > > 	.remove	= __exit_p(my_remove),
> > > };
> > > 
> > > to put them in a new special section? Or is there a better solution?
> > 
> > We already have that:
> > __refdata would be your choice in this case.
> 
> Aha, great! Then also the warning text should be changed, shouldn't it?

Yep - included __refdata in the warning now.

	Sam
