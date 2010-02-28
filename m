Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031411Ab0B1Gfg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 01:35:36 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54494 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031390Ab0B1Gfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 01:35:34 -0500
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       sds@tycho.nsa.gov, jmorris@namei.org
Subject: Re: [PATCH] Security: Add __init to register_security to disable load a security module on runtime
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20100226144955.GB2778@localhost.localdomain>
	<201002271052.AHB64003.OOQLJtFOHVFMSF@I-love.SAKURA.ne.jp>
	<628d1651002261902k6b22277dmfa93c01350c1aed6@mail.gmail.com>
	<201002271530.JCB31845.FOLJMFVFOHtQSO@I-love.SAKURA.ne.jp>
	<628d1651002272156ld6cb7cdmee34117ccf103285@mail.gmail.com>
In-Reply-To: <628d1651002272156ld6cb7cdmee34117ccf103285@mail.gmail.com>
Message-Id: <201002281535.FIB29902.OLFQMHStJFOFOV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 28 Feb 2010 15:35:30 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhitong Wang wrote:
> Load a security module on runtime is not safe on SMP systems,  LSM
> framework doesn't have any locks.

Unloading security module on runtime would be difficult. But loading security
module on runtime is not impossible. A security module can be loaded inside
initramfs if the security module provides appropriate lock.

When AppArmor get merged into mainline, do you want to bother distributors
about size of vmlinux when some wants to use SELinux, some wants to use Smack,
some wants to use TOMOYO, and some wants to use AppArmor. All of them have to
be built-in but only one of them can be enabled.

I think we should allow security modules to be loaded on runtime, if security
modules can provide appropriate lock for SMP-safe initialization.
