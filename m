Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbYHCPCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbYHCPCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 11:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbYHCPCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 11:02:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:21842 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915AbYHCPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 11:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=l6rr/NxKsW54dMCxvidqwBjYCki2hsu+LprdtglMxv1Om3XVTi49egAr0QP4UFYmVa
         4kIkqaQzv7wlzaAb37Zu6LGsc8YgWhZJoITPSyUZXXTeSnQH7SQ3Iz6LVW+T8qCUD5b1
         5OaouPP8J+qttuqdmqHFJFWEk1q0tqOcnYfZ8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 2/2] ide-generic: handle probing of legacy io-ports
Date: Sun, 3 Aug 2008 16:59:55 +0200
User-Agent: KMail/1.9.9
Cc: alan@redhat.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080715053356.GA18628@gollum.tnic> <200808031611.11033.bzolnier@gmail.com> <20080803144539.GA27766@gollum.tnic>
In-Reply-To: <20080803144539.GA27766@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808031659.55953.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 August 2008, Borislav Petkov wrote:

[...]

> > > +		if (probe_mask) {
> > > +			printk(KERN_WARNING "%s: enforcing probing of io ports "
> > > +			       "upon user request.\n", DRV_NAME);
> > > +			primary = 0;
> > > +			secondary = 0;
> > > +		} else
> > > +			printk(KERN_INFO DRV_NAME ": please use "
> > > +			       \"probe_mask=0x3f\" module parameter for probing"
> > > +			       "all legacy ISA IDE ports\n");
> > 
> > Help message is no longer printed for !primary
> > (we always want to have it unless probe_mask is set).
> 
> How about moving that info to Documentation/ide/ide.txt instead? Do we want to
> issue that on every boot, seems like a too unimportant message to be in the
> bootlog to me...

Some time ago we've changed the default from probing all ports to probe
only safe ones (we had to do it because probing all ports may break other
ISA devices) so there may be very unlikely cases when this bugfix caused
regression and we would like people to be able to deduce the workaround
from just reading kernel messages.
