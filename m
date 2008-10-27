Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbYJ0Va7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbYJ0Va7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYJ0Vam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:30:42 -0400
Received: from kroah.org ([198.145.64.141]:34020 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752284AbYJ0Val (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:30:41 -0400
Date: Mon, 27 Oct 2008 14:14:52 -0700
From: Greg KH <greg@kroah.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] w35und: remove dead code from wbusb_f.h
Message-ID: <20081027211452.GA19762@kroah.com>
References: <Pine.LNX.4.64.0810221906140.1679@melkki.cs.Helsinki.FI> <20081027183707.GA13737@kroah.com> <Pine.LNX.4.64.0810272241520.7338@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0810272241520.7338@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 10:44:19PM +0200, Pekka J Enberg wrote:
> Hi Greg,
> 
> On Wed, Oct 22, 2008 at 07:06:41PM +0300, Pekka J Enberg wrote:
> > > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > > 
> > > Remove dead code from wbusb_f.h and move the WbWLanInitialize() definition to
> > > wblinux_f.h where it arguably belongs to. As the wbusb_f.h is now empty, we can
> > > remove it completely.
> > > 
> > > Cc: Pavel Machek <pavel@suse.cz>
> > > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> On Mon, 27 Oct 2008, Greg KH wrote:
> > This patch gives me a bunch of build errors as I don't think you are in
> > sync with the other changes in these files.
> > 
> > Care to respin it against 2.6.28-rc2?
> 
> That's strange. I rebased against 2.6.28-rc2 but didn't get any conficts 
> and everything seems to build just fine. What kind of errors are you 
> seeing?
> 
> I've included the rediffed patch here in case it helps. Not sure why it 
> would...

I still get the following errors with this patch applied:

  CC [M]  drivers/staging/winbond/./linux/wb35reg.o
drivers/staging/winbond/./linux/wb35reg.c: In function ‘Wb35Reg_BurstWrite’:
drivers/staging/winbond/./linux/wb35reg.c:29: error: implicit declaration of function ‘wb_usb_alloc_urb’
drivers/staging/winbond/./linux/wb35reg.c:29: warning: assignment makes pointer from integer without a cast
drivers/staging/winbond/./linux/wb35reg.c: In function ‘Wb35Reg_Write’:
drivers/staging/winbond/./linux/wb35reg.c:178: warning: assignment makes pointer from integer without a cast
drivers/staging/winbond/./linux/wb35reg.c: In function ‘Wb35Reg_WriteWithCallbackValue’:
drivers/staging/winbond/./linux/wb35reg.c:238: warning: assignment makes pointer from integer without a cast
drivers/staging/winbond/./linux/wb35reg.c: In function ‘Wb35Reg_Read’:
drivers/staging/winbond/./linux/wb35reg.c:345: warning: assignment makes pointer from integer without a cast
drivers/staging/winbond/./linux/wb35reg.c: In function ‘Wb35Reg_EP0VM’:
drivers/staging/winbond/./linux/wb35reg.c:437: error: implicit declaration of function ‘wb_usb_submit_urb’
make[2]: *** [drivers/staging/winbond/./linux/wb35reg.o] Error 1

This seems to be because wb_usb_submit_urb() and alloc_urb() are in the
drivers/staging/winbond/linux/wbusb_f.h file when it is removed.

I'll go fix this up by adding another patch removing these entries.
Don't know how they got in here, odd.

thanks,

greg k-h
