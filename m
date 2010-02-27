Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0B0GaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 01:30:11 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:65035 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab0B0GaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 01:30:07 -0500
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       sds@tycho.nsa.gov, jmorris@namei.org
Subject: Re: [PATCH] Security: Add __init to register_security to disable load a security module on runtime
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20100226144955.GB2778@localhost.localdomain>
	<201002271052.AHB64003.OOQLJtFOHVFMSF@I-love.SAKURA.ne.jp>
	<628d1651002261902k6b22277dmfa93c01350c1aed6@mail.gmail.com>
In-Reply-To: <628d1651002261902k6b22277dmfa93c01350c1aed6@mail.gmail.com>
Message-Id: <201002271530.JCB31845.FOLJMFVFOHtQSO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 27 Feb 2010 15:30:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhitong Wang wrote:
> LSM original intention is not allowed to load security modules on runtime, right?

My understanding is that the reason register_security() became no longer
exported to loadable kernel modules is the difficulty of cleanly
initializing/finalizing security modules since security modules usually
allocate/release memory on various structures. When that change happened
(i.e. as of 2.6.24), SELinux was the only in-tree LSM user.

Those security modules which needn't to allocate/release memory on various
structures can be loaded on runtime, if register_security() is exported to
loadable kernel modules.

If a distribution user adds a loadable kernel module (which is not a security
module) which distributor didn't select, the user can get distributor's support
except problems caused by that module.

However, due to limitation that security modules cannot be added as loadable
kernel modules, when a distribution user wants to select security modules which
distributor didn't select, distributor's support is no longer provided
(i.e. not only problems caused by the security modules selected by the user
but also problems caused by the rest of kernel and userland).

What's the difference between a kernel module which uses LSM and a kernel
module which does not use LSM? Any kernel modules can cause severe problems.

My understanding is that LSM's original intention is to allow Linux users to
select security modules. Why LSM places security modules under adverse condition?
