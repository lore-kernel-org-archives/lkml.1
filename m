Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031401Ab0B1F4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 00:56:39 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38276 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0B1F4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 00:56:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=glya8J3n93BS8jSEElskdhrAwwyCsmBcmx0fqxQkJRRzfkiKVhF2DEon1crzlQds4a
         O+frTIrwnPtMmVrd4U5RJhxA9EAdbzotWl283IO2Grm5Lxv0a7JtzBlFVzteS5YaYvtI
         x2Iy5QoQKqDfILqzgLPRsgPnDCZoWDA3rC2AQ=
MIME-Version: 1.0
In-Reply-To: <201002271530.JCB31845.FOLJMFVFOHtQSO@I-love.SAKURA.ne.jp>
References: <20100226144955.GB2778@localhost.localdomain>
	 <201002271052.AHB64003.OOQLJtFOHVFMSF@I-love.SAKURA.ne.jp>
	 <628d1651002261902k6b22277dmfa93c01350c1aed6@mail.gmail.com>
	 <201002271530.JCB31845.FOLJMFVFOHtQSO@I-love.SAKURA.ne.jp>
Date: Sun, 28 Feb 2010 13:56:37 +0800
Message-ID: <628d1651002272156ld6cb7cdmee34117ccf103285@mail.gmail.com>
Subject: Re: [PATCH] Security: Add __init to register_security to disable load 
	a security module on runtime
From: wzt wzt <wzt.wzt@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       sds@tycho.nsa.gov, jmorris@namei.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load a security module on runtime is not safe on SMP systems,  LSM
framework doesn't have any locks.

On Sat, Feb 27, 2010 at 2:30 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Zhitong Wang wrote:
>> LSM original intention is not allowed to load security modules on runtime, right?
>
> My understanding is that the reason register_security() became no longer
> exported to loadable kernel modules is the difficulty of cleanly
> initializing/finalizing security modules since security modules usually
> allocate/release memory on various structures. When that change happened
> (i.e. as of 2.6.24), SELinux was the only in-tree LSM user.
>
> Those security modules which needn't to allocate/release memory on various
> structures can be loaded on runtime, if register_security() is exported to
> loadable kernel modules.
>
> If a distribution user adds a loadable kernel module (which is not a security
> module) which distributor didn't select, the user can get distributor's support
> except problems caused by that module.
>
> However, due to limitation that security modules cannot be added as loadable
> kernel modules, when a distribution user wants to select security modules which
> distributor didn't select, distributor's support is no longer provided
> (i.e. not only problems caused by the security modules selected by the user
> but also problems caused by the rest of kernel and userland).
>
> What's the difference between a kernel module which uses LSM and a kernel
> module which does not use LSM? Any kernel modules can cause severe problems.
>
> My understanding is that LSM's original intention is to allow Linux users to
> select security modules. Why LSM places security modules under adverse condition?
>
