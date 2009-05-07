Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZEGSHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZEGSHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbZEGSHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:07:34 -0400
Received: from science.horizon.com ([192.35.100.1]:54038 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755201AbZEGSHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:07:34 -0400
Date: 7 May 2009 14:07:32 -0400
Message-ID: <20090507180732.27407.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, ulrich.windl@rz.uni-regensburg.de
Subject: Re: [RFC][PATCH] Adjust SHIFT_PLL to improve NTP convergence.
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, williams@redhat.com,
       zippel@linux-m68k.org
In-Reply-To: <4A02C2A7.4033.ED06D54@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IMHO, the "value" of calibration during boot is dubious (unless you just
> reboot a "hot" machine): Usually the machine is cold on reboot, and the
> oscillators will drift a lot initially. Depending on your environment,
> the temperatures inside your box may rise about 10°C or more within a
> few minutes.

> Maybe an experimental feature "recalibrate anytime (and as long as you'd
> like)" would be interesting...

Well, a couple of points come to mind:
- Rebooting hot is not all that unusual.  Less so that with Windows, but
  some of us install test kernels from time to time. :-)
- If you're calibrating the CPU against the PIT, they're often derived
  via PLL from the same clock source, so the *ratio* is fixed, and thus
  the calibration won't drift at all.
- If there were some mechanism to make the divisor consistent across
  boots, that would be helpful.  Imagine a file in /sys that I could
  write with an absolute frequency at boot time as long as it was within
  1000 ppm (0.1%) of the kernel's measurement.

Thinking about it, the third option seems the most useful.  It's
basically a cleaned-up tickadj.
