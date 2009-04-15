Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbZDOCvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbZDOCvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZDOCvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:51:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52969
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752140AbZDOCvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:51:44 -0400
Date: Tue, 14 Apr 2009 19:51:35 -0700 (PDT)
Message-Id: <20090414.195135.105429634.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: linux-kernel@vger.kernel.org, rmk+lkml@arm.linux.org.uk,
       cooloney@kernel.org, starvik@axis.com, takata@linux-m32r.org,
       geert@linux-m68k.org, zippel@linux-m68k.org, lethal@linux-sh.org,
       magnus.damm@gmail.com, wli@holomorphy.com, rth@twiddle.net
Subject: Re: [RFC][PATCH 7/8] Convert sparc to use arch_getoffset()
 infrastructure.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1239760286.6064.44.camel@localhost>
References: <1239759929.6064.38.camel@localhost>
	<1239760000.6064.39.camel@localhost>
	<1239760286.6064.44.camel@localhost>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>
Date: Tue, 14 Apr 2009 18:51:26 -0700

> 	You acked this patch earlier, but I've just tried building with a
> cross-compiler environment I had access to and had problems getting it
> to build.
> 
> It seems the pci_do_get/settimeofday() and the bus_do_get/settimeofday()
> redirection code is causing some trouble. I'm really not sure how the
> BTFIXUPSET_CALL code works, so I don't want to just kill it off. 
> 
> Any advice here on how to do this right?

BTFIXUP is basically a kernel boot time patching service, but
it only works if we can declare function prototypes in the
sparc specific header files.

Since do_gettimeofday() doesn't fall into that requirement, the code
in pci_time_init() is patching the first two instructions of
do_gettimeofday() such that is makes a call to pci_do_gettimeofday().
