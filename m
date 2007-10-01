Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbXJACYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbXJACYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 22:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXJACYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 22:24:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbXJACYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 22:24:38 -0400
Date: Sun, 30 Sep 2007 19:24:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.23-rc8-mm2] System hangs (loops?) during boot
Message-Id: <20070930192419.c8b6e96b.akpm@linux-foundation.org>
In-Reply-To: <200710010207.34430.elendil@planet.nl>
References: <200709282225.21530.elendil@planet.nl>
	<200709302350.30612.elendil@planet.nl>
	<20071001000037.475473bd@laptop.hypervisor.org>
	<200710010207.34430.elendil@planet.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 02:07:33 +0200 Frans Pop <elendil@planet.nl> wrote:

> > That excludes all the extra stuff in -mm and should give us a good hint
> > whether HPET is really at fault.
> 
> The system does boot with rc8 + hrt1.
> 
> Andrew: any suggestions on how to trace the "real" culprit for the hang?

Not really.  Ordinarily one could move hpet-force-enable-on-ich34.patch to
start-of-series, then verify that mainline+hpet-force-enable-on-ich34.patch
works correctly, then just bisect all the other patches.

But tht doesn't work because hpet-force-enable-on-ich34.patch has a
dependency on other patches in the hrt-related patch series, and it could
be that the bug which you've exposed is already in mainline anyway.

If you had a minimal, standalone hpet-force-enable-on-ich34.patch against
mainline then you could test that against mainline.  If that also failed
then you could git-bisect mainline, applying
hpet-force-enable-on-ich34.patch each time (I've done that before).  But
this assumes that you're searching for a regression in minaline.  It may
never have worked.


