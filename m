Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbZFGX3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbZFGX3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 19:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbZFGX3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 19:29:06 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57958 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZFGX3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 19:29:05 -0400
Date: Mon, 8 Jun 2009 00:28:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: alan-jenkins@tuffmail.co.uk
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Corentin Chary <corentin.chary@gmail.com>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
Message-ID: <20090607232856.GA1805@srcf.ucam.org>
References: <4A2934F5.4050601@tuffmail.co.uk> <506D26C038%linux@youmustbejoking.demon.co.uk> <9b2b86520906070841v334d8306ha656c95ee4536261@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86520906070841v334d8306ha656c95ee4536261@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 04:41:30PM +0100, Alan Jenkins wrote:

> Hmm, some cameras have input devices (i.e. buttons). In fact, uvcvideo
> registers an input device on my EEE even though it has no buttons.  I
> think that needs investigating :-(.
> 
> It's quite likely that the buttons can stop working when suspended.
> And there might be other devices with the same IDs, which have a
> button wired up.

A change has recently been committed that results in the button only 
working if the v4l device is open. Otherwise you've got several wakeups 
a second due to the polling of the button endpoint. I'm assuming that 
opening the device disables autosuspend, so I wouldn't worry about that.

It'd be interesting to try enabling autosuspend on all UVC devices. Can 
a driver indicate that its hardware supports it?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
