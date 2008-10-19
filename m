Return-Path: <linux-kernel-owner+w=401wt.eu-S1751802AbYJSQEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbYJSQEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 12:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYJSQEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 12:04:45 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:1831 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYJSQEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 12:04:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pwEKLauOnmxaMYk7EsHSLc2QrOKYi8Wh4t2eOCZ2h/Hm+1knyY/Cm6oFaJIAaSxIHQ
         x/6mmKGh8NTU6JmxbueYe9BZ5S028VOKSHvAz/brh59cWm1PKbXbnRqNVkrZN1wE/X5R
         vlEMpMueIm4zxcW8d2BF2LLC9ywQ3K0Ic1uTU=
Date: Sun, 19 Oct 2008 19:04:25 +0300
From: Yauhen Kharuzhy <jekhor@gmail.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Fix race condition in resume/card detect code
Message-ID: <20081019160422.GA16377@jeknote.loshitsa1.net>
References: <1224173376-25829-1-git-send-email-jekhor@gmail.com> <20081018191147.00327019@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018191147.00327019@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 07:11:47PM +0200, Pierre Ossman wrote:
> On Thu, 16 Oct 2008 19:09:36 +0300
> Yauhen Kharuzhy <jekhor@gmail.com> wrote:
> 
> > When device wakes up by card change interrupt and MMC_UNSAFE_RESUME is
> > enabled then race condition between mmc_rescan() and
> > mmc_resume()/mmc_sd_resume() appeared.
> > 
> > Resume functions can sleep into mmc_remove_card() and at this time
> > mmc_rescan() can be called by delayed work handler. Double-free of
> > kobject or double-remove of host->card can be result of this.
> > 
> > This patch adds an mutex which deny simultaneous executing of
> > mmc_sd_resume()/mmc_resume() and mmc_rescan() functions. Probably, it is
> > not right way.
> > 
> > Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
> > ---
> 
> Can't we just ask the PM layer if this device is currently resuming,
> and if so ignore card notifications from the driver?

What about another idea: mmc_sd_resume() checks if host->detect is
scheduled and if true then it don't try to reinitialize card.
host->detect can be scheduled at this moment only in one case: if device has been waked up by
card change interrupt.

-- 
Yauhen Kharuzhy		jekhor _at_ gmail.com
			JID: jek@jabber.ru

A: No
Q: Should I quote below my post?
