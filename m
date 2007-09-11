Return-Path: <linux-kernel-owner+w=401wt.eu-S1763092AbXIKJkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763092AbXIKJkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 05:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbXIKJkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 05:40:42 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58842 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbXIKJkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 05:40:41 -0400
X-Auth-Info: XncoGJ9DINl7peAoHBM4u6u+3jk5ZUji8yGXqB6hlkE=
X-Auth-Info: XncoGJ9DINl7peAoHBM4u6u+3jk5ZUji8yGXqB6hlkE=
X-Auth-Info: XncoGJ9DINl7peAoHBM4u6u+3jk5ZUji8yGXqB6hlkE=
X-Auth-Info: XncoGJ9DINl7peAoHBM4u6u+3jk5ZUji8yGXqB6hlkE=
Subject: SYSFS: need a noncaching read
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
To: linux-kernel@vger.kernel.org
Cc: Detlev Zundel <dzu@denx.de>, linuxppc-dev@ozlabs.org
Content-Type: text/plain
Organization: DENX
Date: Tue, 11 Sep 2007 11:43:17 +0200
Message-Id: <1189503798.6674.46.camel@Zeus.EmbLux>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have developed a device driver and use the sysFS to export some
registers to userspace. I opened the sysFS File for one register and did
some reads from this File, but I alwas becoming the same value from the
register, whats not OK, because they are changing. So I found out that
the sysFS caches the reads ... :-(

Is there a way to retrigger the reads (in that way, that the sysFS
rereads the values from the driver), without closing and opening the
sysFS Files? Or must I better use the ioctl () Driver-interface for
exporting these registers?

I am asking this, because I must read every 10 ms 2 registers, so
doing a open/read/close for reading one registers is a little bit too
much overhead.

I made a sysFS seek function, which retriggers the read, and that works
fine, but I have again 2 syscalls, whats also is not optimal.

Or can we make a open () with a (new?)Flag, that informs the sysFS to
always reread the values from the underlying driver?

Or a new flag in the "struct attribute_group" in include/linux/sysfs.h,
which let the sysfs rereading the values?

suggestions are welcome

thanks
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

