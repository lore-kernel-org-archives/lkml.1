Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbZGPMVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbZGPMVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 08:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbZGPMVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 08:21:24 -0400
Received: from smtp.nokia.com ([192.100.122.230]:46709 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbZGPMVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 08:21:23 -0400
Subject: Re: block2mtd and ubi are initialized too early when compiled in
 on 2.6.31-rc2
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Tobias Diedrich <ranma@tdiedrich.de>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <20090715115235.GA21888@yamamaya.is-a-geek.org>
References: <20090715115235.GA21888@yamamaya.is-a-geek.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jul 2009 15:20:44 +0300
Message-Id: <1247746844.11353.152.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Jul 2009 12:20:48.0414 (UTC) FILETIME=[D9EFFBE0:01CA060F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-07-15 at 13:52 +0200, Tobias Diedrich wrote:
> On 2.6.31-rc2 the block2mtd drivers module_init is called before any
> block devices have been registered.

Hmm, ok. Is this because block devices are registered asynchronously?
Could you please point to the code where it is done, just for reference.

> Also ubi is initialized pretty early and fails completely if an mtd
> specified on the command line could not be found.

Hmm...

> IMO ubi should at least complete initialization so that attaching
> the mtd later with ubiattach would still work.
> I'm working around this two hacky patches that create a kernel
> thread and retry every second for 20 seconds when the first try
> doesn't work.
> (Obviously this means rootdelay=$somenumber is needed)
> I tried using the async infrastructure, but apparently
> async_synchronize_full is called somewhere between registering the
> async probe thread and the target USB device being registered by the
> USB subsystem, which halts boot until my 20 second timeout, and the
> USB stick is only detected afterwards.
> 
> FWIW I want to use a erasesize aware FS on my USB stick (whose
> builtin FTL has abysmal write performance if writes are less than
> the erasesize) and also be able to use this as my root fs.
> So my setup is usb_storage->block2mtd->ubi->ubifs

Hmm, how other subsystems solve this problem? Any pointer to the code?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

