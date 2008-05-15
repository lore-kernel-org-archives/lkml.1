Return-Path: <linux-kernel-owner+w=401wt.eu-S1764033AbYEOUOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764033AbYEOUOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbYEOUOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:14:01 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:47877 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbYEOUOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:14:00 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] USB: add Sensoray 2255 v4l driver
Date: Thu, 15 May 2008 22:13:59 +0200
User-Agent: KMail/1.9.9
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
References: <20080514205927.GA13134@kroah.com> <200805152154.13630.oliver@neukum.org> <20080515201049.GA24999@kroah.com>
In-Reply-To: <20080515201049.GA24999@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805152214.00400.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 15 Mai 2008 22:10:49 schrieb Greg KH:
> On Thu, May 15, 2008 at 09:54:12PM +0200, Oliver Neukum wrote:
> > Am Donnerstag 15 Mai 2008 20:44:24 schrieb Greg KH:
> > > On Thu, May 15, 2008 at 02:03:18PM +0200, Oliver Neukum wrote:
> > > > Am Donnerstag 15 Mai 2008 13:38:37 schrieb Oliver Neukum:
> > > > > 3. The firmware stuff. That's an interesting solution. However:
> > > > 
> > > > Actually, on second thought, I take that back. It's a bad solution.
> > > > If you don't want to do it in probe(), the only other sensible place
> > > > is in open(). That way you can avoid the whole trouble if nobody
> > > > opens the device. And you need to handle the case of unloaded
> > > > firmware anyway, so you can trigger firmware load there.
> > > 
> > > No, we want to do firmware load on probe, I'll change it to be async so
> > 
> > Could you state your reasons for that preference?
> 
> I don't want to create the device nodes, and have userspace think the
> device really is working, only to have everything fall down and die if
> open() is called and the firmware isn't present.  I'd rather not create
> the video devices if we know this isn't going to work at all.

Yes, that makes sense. However, then you might want to look into
spawning a thread per bus rather than a delayed failure mechanism.

	Regards
		Oliver


