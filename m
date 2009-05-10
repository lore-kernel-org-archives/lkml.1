Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZEJScy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZEJScy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 14:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbZEJSco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 14:32:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:34586 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754795AbZEJScn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 14:32:43 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18VfkpwklkVQsJYY740TcRdu3tOKIfMRxj3PXgOYu
	ADoR3h9nj6eefD
Date: Sun, 10 May 2009 20:33:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: dubious section mismatch test (was Re: [PULL] soc-camera: one
 commit as v4l2-dev preparation)
In-Reply-To: <20090509165416.GA25534@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0905092113280.10748@axis700.grange>
References: <Pine.LNX.4.64.0905071841331.9460@axis700.grange>
 <20090509062726.22d18182@pedra.chehab.org> <Pine.LNX.4.64.0905091430100.3515@axis700.grange>
 <20090509165416.GA25534@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009, Sam Ravnborg wrote:

> On Sat, May 09, 2009 at 06:13:13PM +0200, Guennadi Liakhovetski wrote:
> > On Sat, 9 May 2009, Mauro Carvalho Chehab wrote:
> > 
> > > WARNING: /home/v4l/master/v4l/soc_camera.o(.data+0x0): Section mismatch in reference from the variable soc_camera_pdrv to the function .devinit.text:soc_camera_pdrv_probe()
> > > The variable soc_camera_pdrv references
> > > the function __devinit soc_camera_pdrv_probe()
> > > If the reference is valid then annotate the
> > > variable with __init* (see linux/init.h) or name the variable:
> > > *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 
> > > 
> > > WARNING: /home/v4l/master/v4l/soc_camera.o(.data+0x8): Section mismatch in reference from the variable soc_camera_pdrv to the function .devexit.text:soc_camera_pdrv_remove()
> > > The variable soc_camera_pdrv references
> > > the function __devexit soc_camera_pdrv_remove()
> > > If the reference is valid then annotate the
> > > variable with __exit* (see linux/init.h) or name the variable:
> > > *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 
> > 
> > FWIW, I find this test dubious. Matching on symbol names doesn't seem like 
> > a good idea to me. Can we introduce a new marker instead something like
> > 
> > static struct whatever_driver __driver driver = {
> > 	.probe	= my_probe,
> > 	.remove	= __exit_p(my_remove),
> > };
> > 
> > to put them in a new special section? Or is there a better solution?
> 
> We already have that:
> __refdata would be your choice in this case.

Aha, great! Then also the warning text should be changed, shouldn't it?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
