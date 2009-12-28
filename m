Return-Path: <linux-kernel-owner+w=401wt.eu-S1752128AbZL1Ww0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbZL1Ww0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZL1WwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:52:25 -0500
Received: from lo.gmane.org ([80.91.229.12]:37760 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbZL1WwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:52:25 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH 12/14] USB: oti6858: fix DMA buffer on stack
Date: Mon, 28 Dec 2009 17:51:38 -0500
Message-ID: <20091228175138.24323561@mycelium.queued.net>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
	<1262037718-31424-13-git-send-email-jhovold@gmail.com>
	<20091228174619.3c5b2132@mycelium.queued.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: wireless.queued.net
In-Reply-To: <20091228174619.3c5b2132@mycelium.queued.net>
X-Newsreader: Claws Mail 3.7.3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Cc: linux-usb@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 17:46:19 -0500
Andres Salomon <dilinger@queued.net> wrote:

> On Mon, 28 Dec 2009 23:01:56 +0100
> Johan Hovold <jhovold@gmail.com> wrote:
> 
> [...]
> > diff --git a/drivers/usb/serial/oti6858.c
> > b/drivers/usb/serial/oti6858.c index c644e26..2ae97e7 100644
> > --- a/drivers/usb/serial/oti6858.c
> > +++ b/drivers/usb/serial/oti6858.c
> > @@ -302,7 +302,7 @@ void send_data(struct work_struct *work)
> >  	struct usb_serial_port *port = priv->port;
> >  	int count = 0, result;
> >  	unsigned long flags;
> > -	unsigned char allow;
> > +	u8 *allow;
> >  
> >  	dbg("%s(port = %d)", __func__, port->number);
> >  
> 
> Erm, am I missing something here?  You're removing a 1 byte
> stack variable and replacing it with a 4 byte (pointer) stack
> variable?  What's the point of that, exactly?
> 

Ok, ignore that, I just figured it out (the usb_control_msg bit). :)


