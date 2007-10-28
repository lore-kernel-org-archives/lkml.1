Return-Path: <linux-kernel-owner+w=401wt.eu-S1751752AbXJ1Fa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbXJ1Fa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 01:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbXJ1FaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 01:30:20 -0400
Received: from mxsf07.insightbb.com ([74.128.0.77]:33994 "EHLO
	mxsf07.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbXJ1FaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 01:30:18 -0400
X-IronPort-AV: E=Sophos;i="4.21,338,1188792000"; 
   d="scan'208";a="112274919"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAEW7I0dKjlCP/2dsb2JhbACBWg
X-IronPort-AV: E=Sophos;i="4.21,338,1188792000"; 
   d="scan'208";a="150554039"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] Fujitsu application panel driver
Date: Sun, 28 Oct 2007 01:30:15 -0400
User-Agent: KMail/1.9.3
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net> <200709161623.00286.dtor@insightbb.com> <20071023125555.38d63567@shemminger-laptop>
In-Reply-To: <20071023125555.38d63567@shemminger-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710280130.16002.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tuesday 23 October 2007 15:55, Stephen Hemminger wrote:
> +
> +static int apanel_setkeycode(struct input_dev *idev, int scancode, int keycode)
> +{
> +	struct apanel *ap = idev->private;
> +
> +	if (keycode < 0 || keycode > KEY_MAX)
> +		return -EINVAL;
> +
> +	if (scancode < 0 || scancode >= MAX_PANEL_KEYS)
> +		return -EINVAL;

scancode >= idev->keycodemax is prbably better here - we don't want to
allow setting keycode for unsupported buttons.

> +
> +	clear_bit(ap->keymap[scancode], idev->keybit);

This will not work if one has same code assigned to 2 buttons. Pretty
degenerate case, I know...

> +	ap->keymap[scancode] = keycode;
> +	set_bit(keycode, idev->keybit);
> +	return 0;
> +}

-- 
Dmitry
