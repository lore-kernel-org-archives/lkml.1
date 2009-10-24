Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZJXMEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZJXMEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 08:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZJXMEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 08:04:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37609 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753221AbZJXMEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 08:04:45 -0400
Date: Sat, 24 Oct 2009 08:04:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       <linux-media@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: uvcvideo causes ehci_hcd to halt
In-Reply-To: <4AE2B18A.5080507@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.0910240800440.8254-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Oct 2009, [UTF-8] Ozan Çağlayan wrote:

> Alan Stern wrote:
> > Okay, that proves this really is a timing bug in the hardware.  But we
> > can't go around putting 2-millisecond delays in the kernel!  Maybe you
> > can test to see if smaller delays will fix the problem.  If 50
> > microseconds or less doesn't work then it will be necessary to add a
> > new timer to ehci-hcd.
> >   
> 
> Okay I'll check with smaller values there but I couldn't get the meaning
> of "if 50 us or less doesn't work then it will be necessary to add a new
> timer to ehci-hcd".

If everything works with a delay of 50 us or less then we probably can
just put the udelay() statement into the kernel.  If it doesn't (for
example, if the delay has to be longer than 100 us) then we can't --
the delay would be too long.  Instead we will have to add a new timer.

Alan Stern

