Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbZFKWeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbZFKWeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbZFKWe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:34:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755720AbZFKWe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:34:28 -0400
Date: Thu, 11 Jun 2009 15:32:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH] hwmon: Add driver for VIA CPU core temperature
Message-Id: <20090611153255.ba8d6c54.akpm@linux-foundation.org>
In-Reply-To: <loom.20090610T172830-164@post.gmane.org>
References: <20090609083406.GE25316@prithivi.gnumonks.org>
	<loom.20090610T172830-164@post.gmane.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009 17:40:31 +0000 (UTC)
Tomaz Mertelj <tomaz.mertelj@guest.arnes.si> wrote:

> Harald Welte <HaraldWelte <at> viatech.com> writes:
> 
> > 
> > This is a driver for the on-die digital temperature sensor of
> > VIA's recent CPU models.
> > 
> > Signed-off-by: Harald Welte <HaraldWelte <at> viatech.com>
> > 
> 
> Harald,

You carefully removed Harald from Cc: so he probably didn't read your
email.

> I tested it on 2.6.28.3 kernel on VIA VB7002 motherboard and it does not work 
> correctly.
> 
> Output form sensors:
> 
> via-cputemp-isa-0000
> Adapter: ISA adapter
> Core 0:       +0.0 C
> 
> On the other hand 
> cat '/sys/class/hwmon/hwmon2/device/driver/via-cputemp.0/temp1_input' outputs 
> numbers between 25-27. 
> 

Thanks for testing it.

Harald, please cc myself on updates to this patch.

<looks quickly at the patch>

It has a few trivial coding-style glitches.  Please use checkpatch.

Please take a look at using hotcpu_notifier() rather than a bare
register_hotcpu_notifier().  Many ifdefs should fall away as a result.

