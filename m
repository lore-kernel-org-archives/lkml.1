Return-Path: <linux-kernel-owner+w=401wt.eu-S934506AbYBTUvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506AbYBTUvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759666AbYBTUvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:51:44 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:45038 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbYBTUvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:51:43 -0500
Date: Wed, 20 Feb 2008 21:51:27 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Message-ID: <20080220215127.58b8ec70@mjolnir.drzeus.cx>
In-Reply-To: <Pine.LNX.4.44L0.0802201418520.7056-100000@iolanthe.rowland.org>
References: <20080220183041.46c16ef0@mjolnir.drzeus.cx>
	<Pine.LNX.4.44L0.0802201418520.7056-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 14:26:16 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> 
> Do I understand this correctly?  You've got special handling for the 
> case where a bus handler doesn't have a resume routine, but no special 
> handling for the case where it doesn't have a suspend routine?

Hmm... There should be checks for both, but the code seems to suggest otherwise.

> Why bother to remove the device if neither routine exists (there won't be 
> any need to revive it since the bus never got suspended)?

The bus always gets suspended. The checks are to determine if state is saved or not. If it isn't, then a suspend/resume is treated as a removal/insertion.

> And why not simply fail the suspend if the resume routine doesn't exist
> and the suspend routine does?  Maybe with an error message in the
> system log.

For the asymmetric case, I guess that would do. But I still want to remove devices when the bus handler has no suspend handling.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
