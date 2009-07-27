Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZG0VNC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZG0VNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:13:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbZG0VNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:13:01 -0400
Received: from vena.lwn.net ([206.168.112.25]:58792 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871AbZG0VNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:13:00 -0400
Date: Mon, 27 Jul 2009 15:11:58 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Should I use kmap or kmap_atomic to map user pages that will be
 written in a loop ?
Message-ID: <20090727151158.2c5db4eb@bike.lwn.net>
In-Reply-To: <200907262352.09797.laurent.pinchart@skynet.be>
References: <200907252341.48526.laurent.pinchart@skynet.be>
	<20090726152655.7488abe4@bike.lwn.net>
	<200907262352.09797.laurent.pinchart@skynet.be>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009 23:52:09 +0200
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> I receive data from the USB subsystem in URB buffers, which are small kernel 
> buffers. As I have to strip headers from those buffers, I can't initialize the 
> URBs to copy data directly to the userspace buffers, so there's at least one 
> memcpy operation involved :-S
> 
> I could indeed append the URBs to a list in the callback called from interrupt 
> context, and process them from a threaded interrupt handler. Would it make 
> much difference ?

Moving the actual copying out of interrupt context seems like a good
idea.  And if you can get away from the whole get_user_pages() and
kmap() mess into a straight copy-to-user-space situation, you'll make
your life easier.  So that would be my recommendation, yes.

jon
