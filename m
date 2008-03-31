Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYCaHk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYCaHk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 03:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYCaHkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 03:40:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3733 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753188AbYCaHkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 03:40:18 -0400
Date: Mon, 31 Mar 2008 09:40:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       info-linux@geode.amd.com, jordan.crouse@amd.com
Subject: Re: [PATCH 5/7] lxfb: add power management functionality
Message-ID: <20080331074002.GB5106@ucw.cz>
References: <20080327201050.34a8ffdd@ephemeral>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327201050.34a8ffdd@ephemeral>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +static int lxfb_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct fb_info *info = pci_get_drvdata(pdev);
> +
> +	if (pdev->dev.power.power_state.event == state.event)
> +		return 0;

This should never trigger. See Doc*/feature-removal-sch*.


> +	/* there's no point in setting PCI states; we emulate PCI, so
> +	 * we don't end up getting power savings anyways */
> +
> +	pdev->dev.power.power_state = state;


And there's no point doing this.

> +	pdev->dev.power.power_state = PMSG_ON;

Or this.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
