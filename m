Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbXB1KN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbXB1KN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 05:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932133AbXB1KN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 05:13:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46030 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbXB1KN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 05:13:28 -0500
Subject: Re: Make sure we populate the initroot filesystem late enough
From: David Woodhouse <dwmw2@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       torvalds@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Paul TBBle Hampson <Paul.Hampson@Pobox.com>
In-Reply-To: <1172644987.11949.90.camel@localhost.localdomain>
References: <200612112059.kBBKx1j7022473@hera.kernel.org>
	 <1172448057.3971.9.camel@shinybook.infradead.org>
	 <1172518068.15970.6.camel@localhost> <20070226222724.GA13182@keitarou>
	 <1172558897.11949.43.camel@localhost.localdomain>
	 <3ac1a55a11baddefb903f24b988566fe@kernel.crashing.org>
	 <1172644987.11949.90.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 28 Feb 2007 10:13:04 +0000
Message-Id: <1172657584.3452.51.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-28 at 07:43 +0100, Benjamin Herrenschmidt wrote:
> I wouldn't be that sure ... I've had problems in the past with PMU based
> cpufreq... looks like flushing all caches and hard-resetting the
> processor on the fly when there can be pending DMAs might be a source of
> trouble... especially on CPUs that don't have working cache flush HW
> assist. 

I've seen it on a PowerMac3,1 (400MHz G4) where we don't have cpufreq.
I've also seen it on the latest 1.5GHz Mac Mini, and on my shinybook.
They all fall over with the latest kernel, although the shinybook only
does so immediately when booted with mem=512M. The shinybook does crash
later with new kernels though; I don't yet know why. It could be the
same thing, or it could be something different. That one seemed to
appear between Fedora's 2.6.19-1.2913 and 2.6.19-1.2914 kernels, where
we did nothing but turned CONFIG_SYSFS_DEPRECATED on.

I don't blame cpufreq. At various times I've been equally convinced that
it was due to CONFIG_KPROBES, and Linus' initrd-moving patch.

-- 
dwmw2

