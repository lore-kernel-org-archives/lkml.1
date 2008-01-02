Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbYABUZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbYABUZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYABUZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:25:32 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:41504 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754173AbYABUZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:25:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lgjU4XAuglpUku2wpH70iWJ79kvyYoLtIiaKC8GQ6BuzeC9GFLHRQiJTZCf3WtOCTsxyUa6uhkG0qRlAgoAU7opd+9Z198f1NwatGoSVy+IuOv6r/b+dbkkcSR3MqjFgf36y+t0AVTHWVCfMxt2rUwlZu/e8uXKvq5+R6EvHUhQ=  ;
X-YMail-OSG: H6sz7jgVM1ncybFEYLHlu.H62Csi6YVqC81yvTd3S2ESsk2YaIZBab05QtGGeuwZ7O_te_22Zj2eXuhv2diODA1V0VNHysIbrYg-
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Date: Wed, 2 Jan 2008 12:25:27 -0800
User-Agent: KMail/1.9.6
Cc: Mike Frysinger <vapier.adi@gmail.com>, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net,
       Robin Getz <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0801021444290.2990-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801021444290.2990-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021225.28370.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2008, Alan Stern wrote:
> On Wed, 2 Jan 2008, Mike Frysinger wrote:
> 
> > perhaps the code size is arguable as to whether it really matters.
> > the reason we want it is that we have a USB host controller that will
> > not work with USB hubs, so we want to make sure the system does not
> > attempt such things.  (yes, such a USB host controller is retarded,
> > but the decision was out of our hands.)
> 
> Just out of curiosity, how does a host controller manage to avoid
> working with external hubs? 

The transaction translators in external high speed hubs require
hosts to issue particular USB transactions.  If the host controller
doesn't implement the that split transaction support, then it won't
be supporting external hubs.

The Mentor USB High Speed Dual Role Host Controller silicon IP (using
the aforementioned musb_hdrc driver) is one example of such silicon.
The "Multipoint" licensing option is basically for the TT support,
as I understand it.

One example of its use in a product is with TI's DaVinci chips.  You
can go to http://focus.ti.com/docs/prod/folders/print/tms320dm6446.html
and download the USB controller docs.  Ignore the nasty CPPI DMA glued
onto it, and observe that there are host side TX and RX HUB registers
that won't be present on designs that omit the "multipoint" support.
(Which evidently include one of the Blackfin designs.)

- Dave
