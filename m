Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbYCDUvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbYCDUvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYCDUvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:51:10 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:27323 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752472AbYCDUvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:51:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Eq7IfJmIR6eLTUgOS/kn6tVuCAufdHuaUYnl08k/MbfKwelPsDy8DDRBdaYCfpXNlMw7rNJ6H5vgKiQUaEvyN5stZEUyJLFx2engEIGRQxYAKJpjgh3paxRr+LvITht4yn9eWtEvbUZQbw3LV/DFjiZK/xJSlUZAnnB44uriD9E=  ;
X-YMail-OSG: Z2QwtvUVM1mpchUtstRabrO6raNHpx26.LQtlgJ3spkVBNWOX.Fac6Q.dyEJEOVQxzPph8gJEA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
Date: Tue, 4 Mar 2008 12:51:06 -0800
User-Agent: KMail/1.9.6
Cc: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, 0x0007@gmail.com,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803041118100.4039-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803041118100.4039-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803041251.06725.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008, Alan Stern wrote:
> Dave, it seems to me that this must be an example of a race between the 
> iaa watchdog timer expiring and end_unlink_async() running.  It's not 
> good enough for end_unlink_async() to call iaa_watchdog_done(), because 
> on an SMP system the timer may already have fired and the watchdog 
> routine may be spinning on ehci->lock.

Right.


> How about replacing the
> 
>         WARN_ON(!ehci->reclaim);

Or bettter yet, just removing it entirely.  ISTR doing that in some
patches I've not yet sent for merging, and expect that's what my
preferred fix will be ...

- Dave
