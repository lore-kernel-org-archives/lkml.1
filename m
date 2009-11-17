Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZKQMwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZKQMwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZKQMwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:52:18 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:43691 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZKQMwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:52:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=XGd1Rjg45psgYg0/Dv+5vXZPkgD1B116ZTkGCalFVzf16SC8wl0HVlHvceCaYzLRwR
         OEdr7UlvpGqNdEs6R95+c1B7lG9ifP1+duDqEw0extcQiaaLICk/hItNK0u5JS2qta+v
         aEGoF+KeHNNTm8bElLQdYRMQXtcQukB7C5NVo=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #14380] Video tearing/glitching with T400 laptops
Date: Tue, 17 Nov 2009 13:52:18 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.31-final; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.wG.6TdALB@chimera>
In-Reply-To: <xXQGFmujPl.A.wG.6TdALB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911171352.18563.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 of November 2009, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).

It's mostly gone. It still happens for like 1/4s once per 6hours but jbarnes
asked me to fill separate bug for that and gave such patch for testing (see below).

So far haven't seen 1/4s problem with this patch applied.

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 3ba6546..b2cbf7f 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2491,6 +2491,8 @@ static void g4x_update_wm(struct drm_device *dev,  int planea_clock,
                /* Use ns/us then divide to preserve precision */
                sr_entries = (((sr_latency_ns / line_time_us) + 1) *
                              pixel_size * sr_hdisplay) / 1000;
+               if (sr_entries > G4X_FIFO_SIZE)
+                       sr_entries = G4X_FIFO_SIZE;
                sr_entries = roundup(sr_entries / cacheline_size, 1);
                DRM_DEBUG("self-refresh entries: %d\n", sr_entries);
                I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);

> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14380
> Subject		: Video tearing/glitching with T400 laptops
> Submitter	: Theodore Ts'o <tytso@mit.edu>
> Date		: 2009-10-02 22:40 (46 days old)
> References	: http://marc.info/?l=linux-kernel&m=125452324520623&w=4
> Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
> Patch		: http://marc.info/?l=linux-kernel&m=125591495325000&w=4
> 


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
