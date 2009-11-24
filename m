Return-Path: <linux-kernel-owner+w=401wt.eu-S932717AbZKXKkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbZKXKkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932707AbZKXKkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:40:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53720 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932695AbZKXKkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:40:52 -0500
Date: Tue, 24 Nov 2009 10:40:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: mfd tree build failure
Message-ID: <20091124104057.GA22771@opensource.wolfsonmicro.com>
References: <20091124163753.381d9a83.sfr@canb.auug.org.au> <20091124095715.GA20505@rakim.wolfsonmicro.main> <20091124211433.cd1b7e96.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124211433.cd1b7e96.sfr@canb.auug.org.au>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 09:14:33PM +1100, Stephen Rothwell wrote:

> Sorry, I don't have the actual config (as I overwrite my build directory
> between each merge).  However, if I checkout the mfd tree (alone -
> nothing else in linux-next) and do "make ARCH=x86_64 allmodconfig", I get
> the following in my .config:

> CONFIG_I2C=m
> CONFIG_MFD_CORE=m
> CONFIG_MFD_WM831X=y

Oh, fail.  This is nothing to do with select, it's to do with bool.
Kbuild doesn't propagate the dependency from the boolean (which makes
sense for a lot of uses but not for this one).  The current "fix" used
by other drivers in the same situation is to depend on I2C=y which works
but means that we loose build coverage from allmodconfig.  I'll post a
patch for this shortly.
