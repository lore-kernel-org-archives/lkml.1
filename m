Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYL2SPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYL2SPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 13:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYL2SOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 13:14:53 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:20181 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751266AbYL2SOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 13:14:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FKjBUCE+7obAiSciV8/DLH3yUaTs746hqFzD5pivU76hJuj6B2k10dXn7UpZuazaL834FPDBSeaErG0dV9AVFVgZs7alHGAzhQDU+te2TaiuSR0KJHG7jsW5DjIp5DN7Ixeoz++mtOxupa/hRDJnUsxNuNUWaAuB5os/WbbpjTA=  ;
X-YMail-OSG: 9ePXWhMVM1kWPrZ5cZuuOA_GrhwSPf.KZgMJ_2_T.MDGdB2OayPLjAdKuZpibdMLlqDXygbZLxfY.CcaOzMBf24ZsUPzaqk2c.gUCQ0IxMV.oKRJGTTZovOe_IOl93wQ3nECVXdqsL0z9qETED8nauJsd.ZO29nNkpon2ev86RR5rO0fiyUF0xynVDXv
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Julia Lawall <julia@diku.dk>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 10/13] drivers/usb/gadget: use USB API functions rather than constants
Date: Mon, 29 Dec 2008 10:14:49 -0800
User-Agent: KMail/1.9.10
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.44L0.0812291025220.2250-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0812291628100.9555@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0812291628100.9555@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200812291014.49779.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2008, Julia Lawall wrote:
> > > +#include <linux/usb.h>
> > >  #include <linux/usb/ch9.h>
> > >  #include <linux/usb/gadget.h>
> > 
> > While there's nothing wrong with this part of the patch,

Not so; there *is* something wrong in requiring the
peripheral side support to use a host side header.


> > it hardly  
> > seems necessary.  Was there any reason for including it?
> 
> The new functions are defined in usb.h. I have added the include in 
> this file and in the file epautoconf.c that this file includes.  If it is 
> removed from both, then the code does not compile (after make 
> allyesconfig):

Those functions were supposed to go into <linux/usb/ch9.h>, as
I recall, since they weren't specific to the host side stack.

Having them added to the wrong file is surely part of why
they've only been used by host side drivers.  :)

- Dave



