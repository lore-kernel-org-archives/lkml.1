Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbXG1XzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbXG1XzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 19:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbXG1XzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 19:55:02 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:6568 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbXG1XzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 19:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rHT3u0V2Iaq85Wb163f3oDvEmbe8vnULRBX9HRDXO8TDCi5xskpYUg7jEAqYcdl0T1Dw2IDGSJnaFa+sS1T4Um4hplpUknpydhsTlhAfMhVr7fhHm49a5I7uildd0fnuRPi90dn/wz2dU1mzc3mh83v1C3UkDG41xYnPk1faNkU=
Message-ID: <9a8748490707281655u66e50bbfqba58687b579a85fe@mail.gmail.com>
Date: Sun, 29 Jul 2007 01:55:00 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH] USB Pegasus driver - avoid a potential NULL pointer dereference.
Cc: "Petko Manolov" <petkan@users.sourceforge.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net, netdev@vger.kernel.org
In-Reply-To: <a781481a0707281637n5b123e4aib46c4e4b009b0018@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707290019.02591.jesper.juhl@gmail.com>
	 <a781481a0707281637n5b123e4aib46c4e4b009b0018@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hi,
>
> On 7/29/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > Hello,
> >
> > This patch makes sure we don't dereference a NULL pointer in
> > drivers/net/usb/pegasus.c::write_bulk_callback() in the initial
> > struct net_device *net = pegasus->net; assignment.
> > The existing code checks if 'pegasus' is NULL and bails out if
> > it is, so we better not touch that pointer until after that check.
> > [...]
> > diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> > index a05fd97..04cba6b 100644
> > --- a/drivers/net/usb/pegasus.c
> > +++ b/drivers/net/usb/pegasus.c
> > @@ -768,11 +768,13 @@ done:
> >  static void write_bulk_callback(struct urb *urb)
> >  {
> >         pegasus_t *pegasus = urb->context;
> > -       struct net_device *net = pegasus->net;
> > +       struct net_device *net;
> >
> >         if (!pegasus)
> >                 return;
> >
> > +       net = pegasus->net;
> > +
> >         if (!netif_device_present(net) || !netif_running(net))
> >                 return;
>
> Is it really possible that we're called into this function with
> urb->context == NULL? If not, I'd suggest let's just get rid of
> the check itself, instead.
>
I'm not sure. I am not very familiar with this code. I just figured
that moving the assignment is potentially a little safer and it is
certainly no worse than the current code, so that's a safe and
potentially benneficial change. Removing the check may be safe but I'm
not certain enough to make that call...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
