Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbYE2KgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbYE2KgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 06:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYE2Kfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 06:35:53 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:51868 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYE2Kfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 06:35:52 -0400
Subject: Re: BUG/OOPS: Double Lock in fsl_usb2_udc.c
From: Li Yang <leoli@freescale.com>
Reply-To: leoli@freescale.com
To: David Brownell <david-b@pacbell.net>
Cc: Eugene_Bordenkircher@selinc.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <200805290223.39368.david-b@pacbell.net>
References: <OF581BDA23.991E51FC-ON88257457.007166AD-88257457.007B3064@selinc.com>
	 <20080529014535.6065fa39.akpm@linux-foundation.org>
	 <200805290223.39368.david-b@pacbell.net>
Content-Type: text/plain
Organization: Freescale Semiconductor
Date: Thu, 29 May 2008 18:48:13 +0800
Message-Id: <1212058093.5068.1.camel@Gundam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2008 10:35:46.0810 (UTC) FILETIME=[C148C5A0:01C8C177]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 02:23 -0700, David Brownell wrote:
> > On Wed, 28 May 2008 15:25:31 -0700 Eugene_Bordenkircher@selinc.com wrote:
> > 
> > > Looking through other drivers, I have seen them releasing the lock 
> > > immediately before calling disconnect(), however, without being an expert 
> > > with this driver, I'm not entirely sure that is the best option here. 
> 
> Yeah, general policy is to drop the UDC spinlock whenever
> you call out to gadget driver code, since it may need to
> reenter for various reasons.  (Though if drivers adopt some
> other locking policy that works, that should be fine too.
> Multiple locks don't seem to be needed.)
> 

I will submit a patch to release the lock before calling disconnect().

- Leo

