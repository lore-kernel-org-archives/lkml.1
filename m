Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbZIKMIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbZIKMIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 08:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbZIKMIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 08:08:04 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60833 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbZIKMID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 08:08:03 -0400
To: catalin.marinas@arm.com
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [2.6.31] Memory leak in load_module()?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200909111638.IDC17135.FOHJOtFFMQSVLO@I-love.SAKURA.ne.jp>
	<tnxhbv97rt6.fsf@pc1117.cambridge.arm.com>
	<200909111958.HFG60925.OOQLHFFVtSJOMF@I-love.SAKURA.ne.jp>
	<1252667819.29620.7.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1252667819.29620.7.camel@pc1117.cambridge.arm.com>
Message-Id: <200909112108.EGE48990.SLJFQHMFtOVFOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 11 Sep 2009 21:08:03 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> The object above was allocated by kstrdup via setup_modinfo_srcversion
> but the module loading failed and no other kernel part freed the
> mod->filed object. I think it's a real leak but you could try a few
> "echo scan" to make sure it's not just a temporary false positive.
I did

  while : ; do insmod /lib/modules/2.6.31/kernel/drivers/edac/r82600_edac.ko; sleep 1; echo scan > /sys/kernel/debug/kmemleak ; sleep 10; dmesg -c; done

and verified that

  kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

message appars everytime. This is unlikely temporary false positive.

  unreferenced object 0xdeb89408 (size 32):
    comm "insmod", pid 2969, jiffies 1406494

  unreferenced object 0xde842750 (size 32):
    comm "insmod", pid 2989, jiffies 1514442

  unreferenced object 0xde842a60 (size 32):
    comm "insmod", pid 2993, jiffies 1526889

  unreferenced object 0xdeb89440 (size 32):
    comm "insmod", pid 2999, jiffies 1539244

I'll wait for maintainer's response.

Thank you.
