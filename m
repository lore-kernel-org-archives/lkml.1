Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154Ab0AKQzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab0AKQzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 11:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050Ab0AKQzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 11:55:22 -0500
Received: from outbound-mail-142.bluehost.com ([67.222.38.32]:35700 "HELO
	outbound-mail-142.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751209Ab0AKQzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 11:55:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DUiVz3WONKNsvIhpJjLC8TW9lWWbziDSsmoKVWZYOgz/+28KrdJrq1dHvER94+VvYBSXPrUCAvtXh4cPc17JSf/7L9Bm3cS+t2Ku6v9cNMsqWyOvTLMy1eYq2EcHNQFA;
Date: Mon, 11 Jan 2010 08:55:27 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
Subject: Re: [Bug #14670] i915: playing video via XVideo extension makes the
 screen flicker
Message-ID: <20100111085527.104f5c3e@jbarnes-piketon>
In-Reply-To: <1263228784.12830.0.camel@localhost.localdomain>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
	<CXIfLt-ygXM.A.GGD.GilSLB@chimera>
	<1263228784.12830.0.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jan 2010 17:53:04 +0100
Thomas Meyer <thomas@m3y3r.de> wrote:

> Am Sonntag, den 10.01.2010, 23:56 +0100 schrieb Rafael J. Wysocki:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still
> > should be listed and let me know (either way).
> > 
> 
> Yes, still should be listed.
> 
> Problem still exists in 2.6.32.3 and 2.6.33-rc3-00097-g2c1f189, that
> contains
> this commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cda9d05c499093c67b4a376a15009923acc2127a
> 
> The above commit removes the render reclock support, that ought to
> fix a common kind of problem encountered on i915 hardware, but not on
> my machine.
> 
> Still need to boot with "nomodeset" to have a workable system.

Does this patch prevent the flicker?

-- 
Jesse Barnes, Intel Open Source Technology Center


diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 9187a17..0ab1bef 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3806,7 +3806,7 @@ static void intel_increase_pllclock(struct drm_crtc *crtc, bool schedule)
 	if (IS_IRONLAKE(dev))
 		return;
 
-	if (!dev_priv->lvds_downclock_avail)
+	if (!dev_priv->lvds_downclock_avail || 1)
 		return;
 
 	if (!HAS_PIPE_CXSR(dev) && (dpll & DISPLAY_RATE_SELECT_FPA1)) {
@@ -3845,7 +3845,7 @@ static void intel_decrease_pllclock(struct drm_crtc *crtc)
 	if (IS_IRONLAKE(dev))
 		return;
 
-	if (!dev_priv->lvds_downclock_avail)
+	if (!dev_priv->lvds_downclock_avail || 1)
 		return;
 
 	/*
