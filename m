Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbZAMNxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbZAMNxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759272AbZAMNuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:50:11 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:56196 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758796AbZAMNuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:50:03 -0500
Date: Tue, 13 Jan 2009 14:49:52 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/2] OMAP: HSMMC: Fix response type for busy after
 response
Message-ID: <20090113144952.3f8cbec8@mjolnir.drzeus.cx>
In-Reply-To: <20090113133841.29474.15852.sendpatchset@ahunter-laptop>
References: <20090113133827.29474.92645.sendpatchset@ahunter-laptop>
	<20090113133841.29474.15852.sendpatchset@ahunter-laptop>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 15:38:41 +0200
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

> This also fixes the hidden problem that the controller
> was turning off the clock to the card while the card
> was busy - the clock was then switched on for the
> duration of each Send Status command used for polling,
> which is why writes did not lock up altogether.
> i.e. really dysfunctional.

Does the driver only keep the clock running as long as there is an
ongoing request? That kind of policy should really be handled in the
core where we have more information and can control it better. E.g. some
cards need the clock to finish up internal housekeeping so we need to
delay things for those.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
