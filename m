Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbYF3LPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbYF3LPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 07:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbYF3LPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 07:15:18 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:29068 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755196AbYF3LPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 07:15:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ztRVfC+F1a45o00bGnXXKdcvV3HWdH/wXCTyHo2rujYdY/oyzYsNU4sZApCx1ZRMJH+ZqlYEntlaDkfWdr8zbyPdJenvZQPz6ZndXMij9h2uqpCT3QwIAatwJFiqubjf2mGSeZj5zNt1nrgzr2ldlTFx+yQ7y822thO2TTL8waY=  ;
X-YMail-OSG: eD2OqRAVM1nSBcR7..pxcs3O0Ap9GR_.Le295_lWgH__LeSZ8p7oWFDxxrYB2UI9h5PfFgjh0Xe0jhSOWMu4IDCdcKcr0Iwjbo8OUBB3a0pV2u4SC4eCVvFGJnHsor7fy.w-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Stefan Becker <Stefan.Becker@nokia.com>
Subject: Re: PATCH: 2.6.26-rc8: Fix IRQF_DISABLED for shared interrupts
Date: Mon, 30 Jun 2008 04:15:15 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       ext Alan Stern <stern@rowland.harvard.edu>,
       ext Linus Torvalds <torvalds@linux-foundation.org>
References: <Pine.LNX.4.44L0.0806281241200.23326-100000@netrider.rowland.org> <200806292009.26975.david-b@pacbell.net> <4868A8B1.3090805@nokia.com>
In-Reply-To: <4868A8B1.3090805@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806300415.15796.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2008, Stefan Becker wrote:
> It seems IRQF_SHARED | IRQF_DISABLED has already been discussed several 
> times on LKML:

Given that, I'm surprised that nobody has added a warning that
prints when those two flags are both passed to request_irq().

The problems have been around for a long time, "tested" and known
to be broken.  They'll never go away without nag messages nudging
developers to fix the problems.


> Alan: should I try to implement his choice (f) insteadn, i.e. drop 
> IRQF_DISABLED from USB HCD interrupts and disable interrupts in 
> usb_hcd_irq() instead?

That's the best solution for USB, given that IRQF_DISABLED isn't
going to do what it claims to do.

- Dave


