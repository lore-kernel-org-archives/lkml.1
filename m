Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYADBVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYADBVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 20:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbYADBT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 20:19:57 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:55543 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbYADBTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 20:19:49 -0500
X-IronPort-AV: E=Sophos;i="4.24,241,1196658000"; 
   d="scan'208";a="46169481"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Richard D" <richard@embunus.com>
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Date: Thu, 3 Jan 2008 20:20:47 -0500
User-Agent: KMail/1.9.5
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>,
       "David Brownell" <david-b@pacbell.net>,
       linux-usb-devel@lists.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <200801020948.51310.rgetz@blackfin.uclinux.org> <386072610801030005g7408f333m935c665c82d3412a@mail.gmail.com> <001c01c84e2a$ad3bceb0$07b36c10$@com>
In-Reply-To: <001c01c84e2a$ad3bceb0$07b36c10$@com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801032020.47642.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 04 Jan 2008 01:19:47.0682 (UTC) FILETIME=[E5624C20:01C84E6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 3 Jan 2008 12:04, Richard D pondered:
> Does all USB Host controller hardware have the ability to disable PING?

I think they do. (or at least should)...

http://www.intel.com/technology/usb/download/ehci-r10.pdf
==================
4.11 Ping Control (page 88)

USB 2.0 defines an addition to the protocol for high-speed devices called 
Ping. Ping is required for all USB 2.0 High-speed bulk and control endpoints. 
Ping is not allowed for a split-transaction stream. This extension to the 
protocol eliminates the bad side-effects of Naking OUT endpoints. The Status 
field has a Ping State bit, which the host controller uses to determine the 
next actual PID it will use in the next transaction to the endpoint (see 
Table 3-16).

Table 4–12 illustrates the state transition table for the host controller's 
responsibility for maintaining the PING protocol. 

Refer to Chapter 8 in the USB Specification Revision 2.0 for detailed 
description on the Ping protocol.

===============

I think the musb is just missing the PING/OUT State table, as described in 
table 4-12.

I think this is controlled in the ehci driver with:

host/ehci.h:#define     QTD_STS_PING    (1 << 0)        /* issue PING? */

-Robin
