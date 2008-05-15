Return-Path: <linux-kernel-owner+w=401wt.eu-S1764326AbYEOUL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764326AbYEOUL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762930AbYEOULk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:11:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60586 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761089AbYEOULj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:11:39 -0400
Date: Thu, 15 May 2008 13:10:49 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
Subject: Re: [PATCH] USB: add Sensoray 2255 v4l driver
Message-ID: <20080515201049.GA24999@kroah.com>
References: <20080514205927.GA13134@kroah.com> <200805151403.19323.oliver@neukum.org> <20080515184424.GD15231@kroah.com> <200805152154.13630.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805152154.13630.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 09:54:12PM +0200, Oliver Neukum wrote:
> Am Donnerstag 15 Mai 2008 20:44:24 schrieb Greg KH:
> > On Thu, May 15, 2008 at 02:03:18PM +0200, Oliver Neukum wrote:
> > > Am Donnerstag 15 Mai 2008 13:38:37 schrieb Oliver Neukum:
> > > > 3. The firmware stuff. That's an interesting solution. However:
> > > 
> > > Actually, on second thought, I take that back. It's a bad solution.
> > > If you don't want to do it in probe(), the only other sensible place
> > > is in open(). That way you can avoid the whole trouble if nobody
> > > opens the device. And you need to handle the case of unloaded
> > > firmware anyway, so you can trigger firmware load there.
> > 
> > No, we want to do firmware load on probe, I'll change it to be async so
> 
> Could you state your reasons for that preference?

I don't want to create the device nodes, and have userspace think the
device really is working, only to have everything fall down and die if
open() is called and the firmware isn't present.  I'd rather not create
the video devices if we know this isn't going to work at all.

Just trying to be nicer to users who would get very confused, "but wait,
the device nodes are there, and the application finds the device, why is
it not working properly?"

thanks,

greg k-h
