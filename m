Return-Path: <linux-kernel-owner+w=401wt.eu-S964789AbXCKXjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789AbXCKXjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 19:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964810AbXCKXjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 19:39:46 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:52853 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789AbXCKXjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 19:39:45 -0400
Message-ID: <45F4934A.3030303@drzeus.cx>
Date: Mon, 12 Mar 2007 00:39:54 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Philip Langdale <philipl@overt.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>, juha.yrjola@solidboot.com
Subject: Re: [PATCH] MMC: Clean up low voltage range handling
References: <45F33C2C.2090905@overt.org>
In-Reply-To: <45F33C2C.2090905@overt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philip Langdale wrote:
> Clean up the handling of low voltage MMC cards.
>
>   
> The latest MMC and SD specs both agree that the low
> voltage range is defined as 1.65-1.95V and is signified
> by bit 7 in the OCR. An old Sandisk spec implied that
> bits 7-0 represented voltages below 2.0V in 1V increments,
> and the code was accordingly written with that expectation.
>
>   

We must not have the same specs. My simplified SD 2.0 physical spec
defines everything below bit 15 as reserved.

> This change switches the code to conform to the specs and
> fixes the SDHCI driver. It also removes the explicit
> defines for the host vdd and updates the SDHCI driver
> to convert the bit number back to the mask value
> for comparisons. Having only a single set of defines
> ensures there's nothing to get out of sync.
>
>   

Although this is a nice change, it confuses things to have two changes
in one commit. Could you split them up and base it on my "for-andrew"
branch?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

