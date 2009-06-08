Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbZFHNAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbZFHNAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZFHNAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:00:15 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:46617 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbZFHNAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:00:10 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 2/2] CPUFREQ: Mark e_powersaver driver as EXPERIMENTAL and DANGEROUS
Date: Mon, 8 Jun 2009 08:00:07 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <20090608102936.GQ4106@prithivi.gnumonks.org> <20090608120846.GA13328@srcf.ucam.org>
In-Reply-To: <20090608120846.GA13328@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906080800.10312.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon June 8 2009, Matthew Garrett wrote:
> On Mon, Jun 08, 2009 at 06:29:36PM +0800, Harald Welte wrote:
> > The e_powersaver driver for VIA's C7 CPU's needs to be marked as
> > DANGEROUS as it configures the CPU to power states that are out
> > of specification.
> > 
> > According to Centaur, all systems with C7 and Nano CPU's support
> > the ACPI p-state method.  Thus, the acpi-cpufreq driver should
> > be used instead.
> 
> Do we know if vendors are actually shipping with the appropriate BIOS 
> tables? The number of people using e_powersaver seems to be suspiciously 
> large, though perhaps that's just because the help text implied it was 
> the right choice for C7.
> 

In part, it was because acpi_freq would not load - H.W. in another post
has proposed a fix for that.

My test machine is a "first production" of the Everex Cloudbook - -
About as early as you can get of something in the public hands -
If there is something lacking in a machine's BIOS - it should be
missing in this one - I can test for that condition.
(This one is hitting user code with the silicon still setup
in the state set by "#reset" - untouched by the BIOS.)

Of course, that says nothing about other and/or newer machines -
At the moment I am toying with the idea of a cpu-quirks routine
that could check/correct for an incompletely setup chip.
On the Model-D chips, that could also switch the processor over
to its on-silicon thermal/power/freq adaptive controller.

All of the Netbooks that I know of have shipped with the Model-D
processor (ULV) - so the above cpu-quirks routine would "fix" those.

Machines running other C7 models...
They will just have to trust the BIOS and/or a repaired e_powersaver.

Mike
