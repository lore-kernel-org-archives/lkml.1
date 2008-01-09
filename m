Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYAIVvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYAIVvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYAIVu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:50:57 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44282 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYAIVu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:50:56 -0500
To: andi@firstfloor.org
CC: harvey.harrison@gmail.com, jdike@addtoit.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
In-reply-to: <20080109213258.GC15612@one.firstfloor.org> (message from Andi
	Kleen on Wed, 9 Jan 2008 22:32:58 +0100)
Subject: Re: uml and -regparm=3
References: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu> <p734pdmput0.fsf@bingen.suse.de> <E1JCiLx-0006lI-HR@pomaz-ex.szeredi.hu> <20080109213258.GC15612@one.firstfloor.org>
Message-Id: <E1JCioy-0006os-6i@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Jan 2008 22:50:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FASTCALL is useless and should not make a difference. It enables
> regparm on specific functions, but that should not make a difference
> if it works or not.

__down_write() in include/asm-x86/rwsem.h seems to assume, that the
semaphore pointer is passed in %eax down to rwsem_down_write_failed(),
so regparm does make a difference there.

There's also some intervening magic in arch/x86/lib/semaphore_32.S,
that I don't quite understand, but which doesn't seem to make a
difference.

Miklos
