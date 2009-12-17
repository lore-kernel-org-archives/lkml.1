Return-Path: <linux-kernel-owner+w=401wt.eu-S1764938AbZLQRBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764938AbZLQRBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762414AbZLQRBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:01:50 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:62593 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbZLQRBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:01:49 -0500
MIME-Version: 1.0
In-Reply-To: <20091216060130.GD31265@linux-sh.org>
References: <20091216060130.GD31265@linux-sh.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 17 Dec 2009 09:01:25 -0800
X-Google-Sender-Auth: 75be097e77013415
Message-ID: <fa686aa40912170901p6af26715l5f009ba96d1e1341@mail.gmail.com>
Subject: Re: [PATCH] spi: xilinx_spi: Fix up I/O routine wrapping bogosity.
To: Paul Mundt <lethal@linux-sh.org>
Cc: John Linn <John.Linn@xilinx.com>, richard.rojfors@mocean-labs.com,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 10:01 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> xilinx_spi presently makes some fairly questionable assumptions about I/O
> routines, and attempts to assign ioread32/iowrite32 and friends directly
> to its own internal function pointers. On many platforms these I/O
> routines are macros or wrappers and not actual functions on their own,
> resulting in things like:
>
> ERROR: "ioread32be" [drivers/spi/xilinx_spi.ko] undefined!
> ERROR: "iowrite32be" [drivers/spi/xilinx_spi.ko] undefined!
> ERROR: "iowrite32" [drivers/spi/xilinx_spi.ko] undefined!
> ERROR: "ioread32" [drivers/spi/xilinx_spi.ko] undefined!

Unfortunately, ARM doesn't have either ioread32be or iowrite32be
defined, so the problem is still not solved with this patch.  I've
crafted a patch to add them which I'll send to the ARM list right now.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
