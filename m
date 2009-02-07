Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZBGFjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZBGFjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 00:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZBGFiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 00:38:52 -0500
Received: from kroah.org ([198.145.64.141]:58146 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754120AbZBGFiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 00:38:50 -0500
Date: Fri, 6 Feb 2009 21:34:09 -0800
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Bryan Wu <cooloney@kernel.org>, felipe.balbi@nokia.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: musb: tweak musb_read_fifo() to avoid unused
	warnings
Message-ID: <20090207053409.GB14918@kroah.com>
References: <1233915736-18506-1-git-send-email-cooloney@kernel.org> <20090207000148.GF31059@kroah.com> <8bd0f97a0902062029l7cfd58d2ga0c12f2c33cc9d93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0902062029l7cfd58d2ga0c12f2c33cc9d93@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 11:29:54PM -0500, Mike Frysinger wrote:
> On Fri, Feb 6, 2009 at 19:01, Greg KH wrote:
> > On Fri, Feb 06, 2009 at 06:22:16PM +0800, Bryan Wu wrote:
> >> From: Mike Frysinger <vapier.adi@gmail.com>
> >>
> >> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> >> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> >> ---
> >>  drivers/usb/musb/blackfin.c |    9 +++++----
> >>  1 files changed, 5 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
> >> index 7861348..0ebb19d 100644
> >> --- a/drivers/usb/musb/blackfin.c
> >> +++ b/drivers/usb/musb/blackfin.c
> >> @@ -54,13 +54,11 @@ void musb_write_fifo(struct musb_hw_ep *hw_ep, u16 len, const u8 *src)
> >>  void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
> >>  {
> >>       void __iomem *fifo = hw_ep->fifo;
> >> +
> >> +#ifdef CONFIG_BF52x
> >
> > Any way we can just not have ifdefs in .c files alltogether?
> 
> the sub arch.c files for musb are pretty much header files.  the
> alternative (splitting up the funcs into their own header files) would
> be much more bothersome for us to maintain atm i think since there's
> so very little different.

Ick.  Oh well, any cleanup that people can think of would be good in
this area...

thanks,

greg k-h
