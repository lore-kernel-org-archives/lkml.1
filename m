Return-Path: <linux-kernel-owner+w=401wt.eu-S933576AbXEQBMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbXEQBMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 21:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbXEQBMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 21:12:25 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53873
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbXEQBMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 21:12:24 -0400
From: Rob Landley <rob@landley.net>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Subject: Re: UML doesn't compile in 2.6.21
Date: Wed, 16 May 2007 21:11:18 -0400
User-Agent: KMail/1.9.1
Cc: LKML <linux-kernel@vger.kernel.org>, jdike@karaya.com
References: <20070516224938.GN12319@pengutronix.de>
In-Reply-To: <20070516224938.GN12319@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705162111.19123.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 6:49 pm, Robert Schwebel wrote:
> Jeff,
> 
> Any idea how this could happen? I'm trying to build 2.6.21 for ARCH=um, and 
the
> linker stage explodes here:

2.6.21.1 built for me:

tar xvjf linux-2.6.21.1.tar.bz2 &&
cd linux-2.6.21.1 &&
cat > mini.conf << EOF
CONFIG_MODE_SKAS=y
CONFIG_BINFMT_ELF=y
CONFIG_HOSTFS=y
CONFIG_SYSCTL=y
CONFIG_STDERR_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_LBD=y
CONFIG_EXT2_FS=y
CONFIG_PROC_FS=y
EOF
make ARCH=um allnoconfig KCONFIG_ALLCONFIG=mini.conf &&
make ARCH=um &&
./linux rootfstype=hostfs rw init=/bin/sh

Does this not work for you?

Rob
