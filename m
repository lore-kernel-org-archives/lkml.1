Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbXI3IaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbXI3IaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 04:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbXI3IaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 04:30:09 -0400
Received: from sirius.lasnet.de ([62.75.240.18]:50493 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbXI3IaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 04:30:07 -0400
From: Jan Luebbe <jluebbe@lasnet.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <20070930072056.GA18108@elte.hu>
References: <1191084471.24185.11.camel@polaris>
	 <20070930072056.GA18108@elte.hu>
Content-Type: text/plain; charset=UTF-7
Date: Sun, 30 Sep 2007 10:31:05 +0200
Message-Id: <1191141065.10375.9.camel@polaris>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] fix console change race exposed by CFS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-30 at 09:20 +-0200, Ingo Molnar wrote:
+AD4 +ACo Jan Luebbe +ADw-jluebbe+AEA-lasnet.de+AD4 wrote:
+AD4 +AD4 From: Jan L+APw-bbe +ADw-jluebbe+AEA-lasnet.de+AD4
+AD4 +AD4 
+AD4 +AD4 The new behaviour of CFS exposes a race which occurs if a switch is
+AD4 +AD4 requested when vt+AF8-mode.mode is VT+AF8-PROCESS.
+AD4 +AD4 
+AD4 +AD4 The process with vc-+AD4-vt+AF8-pid is signaled before vc-+AD4-vt+AF8-newvt is set. This
+AD4 +AD4 causes the switch to fail when triggered by the monitoing process
+AD4 +AD4 because the target is still -1.
+AD4 +AD4 
+AD4 +AD4 Signed-off-by: Jan L+APw-bbe +ADw-jluebbe+AEA-lasnet.de+AD4
+AD4 
+AD4 nifty+ACE I'm wondering what the symptoms of this bug were - how did you 
+AD4 notice it? Also, i'm wondering how you managed to debug this - looks 
+AD4 quite hard to trigger this race, right?
+AD4 
+AD4 Acked-by: Ingo Molnar +ADw-mingo+AEA-elte.hu+AD4
+AD4 
+AD4 	Ingo

I'm currenly porting the OpenMoko patchset to 2.6.23-rc8. We are using
psplash and kdrive. When booting, I got an error from psplash about
being unable to switch consoles. Strangely, it was possible to start
kdrive manually. So i set up qemu for kernel debugging, set some
interesting breakpoints and then saw that it was scheduling away
directly after the kill+AF8-pid. Then it was quite obvious.

It was triggering every time, on the device and in qemu identically.
Most people testing the RCs probably don't run psplash (or any other
program which sets vt+AF8-mode.mode to VT+AF8-PROCESS), so it wasn't noticed
earlier.

Jan

