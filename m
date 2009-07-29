Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZG2I5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZG2I5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 04:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZG2I5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 04:57:00 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:44659 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZG2I47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 04:56:59 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: Should I use kmap or kmap_atomic to map user pages that will be written in a loop ?
Date: Wed, 29 Jul 2009 10:58:23 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200907252341.48526.laurent.pinchart@skynet.be> <200907262352.09797.laurent.pinchart@skynet.be> <20090727151158.2c5db4eb@bike.lwn.net>
In-Reply-To: <20090727151158.2c5db4eb@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907291058.23390.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Monday 27 July 2009 23:11:58 Jonathan Corbet wrote:
> On Sun, 26 Jul 2009 23:52:09 +0200 Laurent Pinchart wrote:
> > I receive data from the USB subsystem in URB buffers, which are small
> > kernel buffers. As I have to strip headers from those buffers, I can't
> > initialize the URBs to copy data directly to the userspace buffers, so
> > there's at least one memcpy operation involved :-S
> >
> > I could indeed append the URBs to a list in the callback called from
> > interrupt context, and process them from a threaded interrupt handler.
> > Would it make much difference ?
>
> Moving the actual copying out of interrupt context seems like a good
> idea.  And if you can get away from the whole get_user_pages() and
> kmap() mess into a straight copy-to-user-space situation, you'll make
> your life easier.  So that would be my recommendation, yes.

Thanks. I'll try that, it will make my life easier.

Regards,

Laurent Pinchart

