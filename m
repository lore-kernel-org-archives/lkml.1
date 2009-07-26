Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbZGZVuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbZGZVuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 17:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZGZVuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 17:50:52 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:38045 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbZGZVuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 17:50:51 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: Should I use kmap or kmap_atomic to map user pages that will be written in a loop ?
Date: Sun, 26 Jul 2009 23:52:09 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200907252341.48526.laurent.pinchart@skynet.be> <20090726152655.7488abe4@bike.lwn.net>
In-Reply-To: <20090726152655.7488abe4@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907262352.09797.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

first of all thanks for your answer.

On Sunday 26 July 2009 23:26:55 Jonathan Corbet wrote:
> On Sat, 25 Jul 2009 23:41:47 +0200
>
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > Pages will be written to from the kernel in USB interrupt context. I can
> > then either kmap_atomic() pages before copying data and kunmap_atomic()
> > them right after, or kmap() them once at the beginning of the video
> > stream and keep them mapped until the end.
>
> Video buffers can be big, and the streaming interface requires at least
> two of them.  That's a lot of kmap'd pages.  It seems to me that
> kmap_atomic() is the way to go for something like this.

Ok thanks.

> But, then, these are user-space buffers, and you're seemingly buffering
> the data through kernel space buffers first?  It seems like using
> copy_to_user() in a workqueue (or a threaded interrupt handler) might be
> a more straightforward way to go, unless I'm missing something.

I receive data from the USB subsystem in URB buffers, which are small kernel 
buffers. As I have to strip headers from those buffers, I can't initialize the 
URBs to copy data directly to the userspace buffers, so there's at least one 
memcpy operation involved :-S

I could indeed append the URBs to a list in the callback called from interrupt 
context, and process them from a threaded interrupt handler. Would it make 
much difference ?

Regards,

Laurent Pinchart

