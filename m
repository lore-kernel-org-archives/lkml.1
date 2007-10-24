Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbXJXOEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbXJXOEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbXJXOER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:04:17 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:57806 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbXJXOEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:04:16 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: USB: FIx locks and urb->status in adutux
Date: Wed, 24 Oct 2007 16:04:42 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-usb-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org, vitalivanov@gmail.com, netwiz@crc.id.au
References: <20071022203447.db6d7950.zaitcev@redhat.com> <200710231138.38266.oliver@neukum.org> <20071023143852.df06530a.zaitcev@redhat.com>
In-Reply-To: <20071023143852.df06530a.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710241604.42832.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 23 Oktober 2007 schrieb Pete Zaitcev:
> On Tue, 23 Oct 2007 11:38:37 +0200, Oliver Neukum <oliver@neukum.org> wrote:
> 
> > > +   /* XXX Anchor these instead */
> > > +   spin_lock_irqsave(&dev->buflock, flags);
> > > +   if (!dev->read_urb_finished) {
> > > +           spin_unlock_irqrestore(&dev->buflock, flags);
> > > +           usb_kill_urb(dev->interrupt_in_urb);
> > > +   } else
> > > +           spin_unlock_irqrestore(&dev->buflock, flags);
> 
> > Why bother? Simply call usb_kill_urb() unconditionally.
> 
> Is it always safe to kill unfilled URBs? The filled but unsubmitted ones
> are ok, but in this case it's possible that we only allocated something
> but never submitted. Our current implementation happens to be safe by
> virtue of ->dev being NULL in such case. I do not remember if we always
> guaranteed that and since Vitaly is going to take this code for a
> backport, I decided to play it safe.

I am not sure as far as 2.4 is concerned. In fact I am not sure 2.4 has
usb_kill_urb() at all.

	Regards
		Oliver

