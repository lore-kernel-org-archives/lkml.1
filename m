Return-Path: <linux-kernel-owner+w=401wt.eu-S932578AbZKXJ5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbZKXJ5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932528AbZKXJ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:57:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35285 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932481AbZKXJ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:57:11 -0500
Date: Tue, 24 Nov 2009 09:57:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: mfd tree build failure
Message-ID: <20091124095715.GA20505@rakim.wolfsonmicro.main>
References: <20091124163753.381d9a83.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124163753.381d9a83.sfr@canb.auug.org.au>
X-Cookie: The people rule.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 04:37:53PM +1100, Stephen Rothwell wrote:

> drivers/built-in.o: In function `wm831x_i2c_remove':
> wm831x-core.c:(.text+0xd108b): undefined reference to `mfd_remove_devices'
> drivers/built-in.o: In function `wm831x_i2c_write_device':
> wm831x-core.c:(.text+0xd119c): undefined reference to `i2c_master_send'
> drivers/built-in.o: In function `wm831x_i2c_read_device':
> wm831x-core.c:(.text+0xd1208): undefined reference to `i2c_master_send'
> wm831x-core.c:(.text+0xd1237): undefined reference to `i2c_master_recv'

> Caused by commit 4f7231a3ff624ad8a0fdace424b10a8b262071cf ("mfd: Don't
> allow wm831x to be built as a module").  CONFIG_MFD_CORE is "m" and
> CONFIG_I2C is "m" while CONFIG_MFD_WM831X is "y".  "select" is a real
> problem :-(

There's something more seriously wrong than the select with your config
here - the driver depends on (rather than selecting) I2C and you're also
seeing undefined references to the I2C API.  The select on MFD_CORE
should also be forcing that to be built in (it does normally).

Could you please post the actual configuration you're using?  I suspect
some Kbuild bug has been triggered here...
