Return-Path: <linux-kernel-owner+w=401wt.eu-S932272AbZLHPmC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbZLHPmC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:42:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbZLHPmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:42:01 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39630 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbZLHPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:41:58 -0500
Date: Tue, 8 Dec 2009 15:41:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net,
       Corentin Chary <corentin.chary@gmail.com>,
       Alexandre Rostovtsev <tetromino@gmail.com>
Subject: Re: [Resend] [PATCH] asus-laptop: add Lenovo SL LenovoCare LED
	support
Message-ID: <20091208154154.GA26435@srcf.ucam.org>
References: <1260257829-7343-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260257829-7343-1-git-send-email-ike.pan@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 03:37:09PM +0800, Ike Panhc wrote:

>  ASUS_HANDLE(rled_set, ASUS_HOTK_PREFIX "RLED");	/* W1JC */
>  ASUS_HANDLE(pled_set, ASUS_HOTK_PREFIX "PLED");	/* A7J */
>  ASUS_HANDLE(gled_set, ASUS_HOTK_PREFIX "GLED");	/* G1, G2 (probably) */

The driver is controlling the ATKD device, which has a HID of ATK0101. 
These devices are all underneath it...

> +ASUS_HANDLE(lled_set, "\\_SB_.PCI0.SBRG.EC0_.HKEY.TVLS"); /* LenovoCare */

And this one isn't, which is a bit jarring. Looking closer, it's under 
the LEN0014 device, which means that you're trying to touch a method 
that belongs to a device other than the one this driver is bound to. 
That's wrong. You want a separate ACPI driver for the LEN0014 device, 
and this should be called for there. Looking at it, you seem to get 
rfkill as well (the GWAN/SWAN, GBDC/SBDF and GUWB/SUWB methods) and 
maybe some other stuff.

So this shouldn't go in asus-laptop. You'll need to add another separate 
driver for the SL-specific functionality.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
