Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbZI2LfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbZI2LfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 07:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZI2LfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 07:35:17 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:42305 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbZI2LfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 07:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pdeDMT7JhUBdSulRUTHayHUzIIbZc5Qj8tyRnbsq9Og4laqhIM2M61VvbtwxicyuyB
         hM0EX6HI+p6Rl4LWbs44QYPCF/ub2zxbU9tRsuqZTlBEwbvRzPJf6tVtu7bcEez4XzRT
         g0GI7dNj/JNp+NF7Fp/ojSmKAkDh1DQ7wNvRU=
Date: Tue, 29 Sep 2009 13:35:18 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Johan Hovold <jhovold@gmail.com>, Peter Berger <pberger@brimson.com>,
       Al Borchers <alborchers@steinerpoint.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: digi_acceleport: Fix broken unthrottle.
Message-ID: <20090929113518.GE2152@localhost>
References: <20090929103923.GA2866@localhost>
 <200909291320.46815.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909291320.46815.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 01:20:44PM +0200, Oliver Neukum wrote:
> Am Dienstag, 29. September 2009 12:39:23 schrieb Johan Hovold:
> > This patch is untested as I haven't got the hardware, but seems
> > straight-forward to me.
> >
> > Can you verify, Oliver?
> 
> I would prefer to see a check in usb-serial.c::serial_unthrottle()

This is completely unrelated to the unthrottle issue discussed elsewhere. :)

The digi_acceleport unthrottle code should (and used to) check
priv->dp_throttle_restart to determine whether to resubmit and then
cleared the flag. The commit mentioned mistakenly, I assume, reversed this.
Plain bug. Right?

