Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420Ab0ALRfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0ALRfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329Ab0ALRfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:35:08 -0500
Received: from outbound-mail-154.bluehost.com ([67.222.39.34]:48964 "HELO
	outbound-mail-154.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751694Ab0ALRfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:35:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=L+XtB73Y9G+gC7z7Tg19YsjbRS15GqIr79KHL/sYa5NtuvTGh4EfnzJeSXTwpsxG0hVLRDO4pqAXmAWk9xvfXwW4g7X++/h4glonlqyc0DygGfo3bREkrWwyuwRymuSc;
Date: Tue, 12 Jan 2010 09:34:54 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: James Simmons <jsimmons@infradead.org>
Cc: David John <davidjon@xenontk.org>, Johan Hovold <jhovold@gmail.com>,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH] drm/kms: fix fbdev blanking regression
Message-ID: <20100112093454.57176b8c@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1001121645570.9778@casper.infradead.org>
References: <1262797226-9593-1-git-send-email-jhovold@gmail.com>
	<1262797226-9593-2-git-send-email-jhovold@gmail.com>
	<alpine.LFD.2.00.1001061710510.5372@casper.infradead.org>
	<20100106180950.GD10442@localhost>
	<alpine.LFD.2.00.1001061814360.5372@casper.infradead.org>
	<20100106191234.GE10442@localhost>
	<4B458209.2030600@xenontk.org>
	<alpine.LFD.2.00.1001121645570.9778@casper.infradead.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 17:28:33 +0000 (GMT)
James Simmons <jsimmons@infradead.org> wrote:

> 
> > On 01/07/2010 12:42 AM, Johan Hovold wrote:
> > >> Yeap. The fix uncovered a bug in your driver. I haven't heard of
> > >> problems with the other drm drivers.
> > >>  
> > >>> The backlight is handled via the DRI driver I assume. At least
> > >>> i9xx_crtc_dpms is called on powerdown.
> > >>
> > >> Can you post your dmesg and kernel config.
> > 
> > [snip]
> > 
> > Adding the Intel DRM people in CC as well. I have the same issue
> > with my GM45.
> 
> Okay I looked at the code to figure out what is happening and why
> only this driver has problems. The problem is that the framebuffer
> layer expects the backlight to be a seperate device. The reason being
> is that some embedded systems will use a gpio backlight. That way
> power management for a graphics card/backlight has 3 seperate states.
> Currently the intel DRM driver treats the backlight as being apart of
> the encoder. Jesse do you have objections to having the intel driver
> expose a backlight device. The bonus of that is the user can also set
> the backlight levels.

On Intel we usually expect the backlight to be exposed by ACPI or a
platform driver.  On recent platforms, the ACPI driver will actually
send requests to the gfx driver to do the actual register writes to
adjust the backlight, but it's still ACPI driven.

Maybe we just need to wire up the fb backlight hooks appropriately?

-- 
Jesse Barnes, Intel Open Source Technology Center
