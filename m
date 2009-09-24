Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbZIXVPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbZIXVPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZIXVPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:15:00 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:61659 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbZIXVO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:14:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BooL2cfRsLAgGGTZ85NJvQ9OuiT07syhMus/ZjraIt/D+OiOfdnkubnnOoLCzkKejy
         LXFCdplmDYCERqV59VErAhO/P0g4Kfb3B/w3ovy8iGGikn+/ypxorQ5I0DhraYp5lZzy
         0RheDGxxth/TBtmYpWlDiJB2tH8ZbLGdxDG9g=
Date: Thu, 24 Sep 2009 23:15:00 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oliver Neukum <oliver@neukum.org>, Johan Hovold <jhovold@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20090924211459.GB27963@localhost>
References: <20090924154023.GA27480@localhost>
 <200909242103.48562.oliver@neukum.org>
 <20090924202107.4730f2af@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924202107.4730f2af@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 08:21:07PM +0100, Alan Cox wrote:
> On Thu, 24 Sep 2009 21:03:47 +0200
> Oliver Neukum <oliver@neukum.org> wrote:

> > Am Donnerstag, 24. September 2009 17:40:23 schrieb Johan Hovold:
> > > Is there a reason why this was not fixed in ftdi_sio (and whiteheat?)
> > > along with the other drivers?

> > No good reason. They escaped my grep pattern. Mea culpa.

> ftdi_sio is correct with low_latency set as it uses a work queue to
> process the packets received.

AFAICT it only uses the work queue if tty_buffer_request_room fails to
allocate enough space. This being the exception, the completion
handler normally processes the packets in interrupt context and this is
where I get my lockdep traces (and it happens every time I hit the echo
or throttle paths).

/Johan

