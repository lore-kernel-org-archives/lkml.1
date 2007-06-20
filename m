Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbXFTUbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbXFTUbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXFTUbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:31:39 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:53190
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbXFTUbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:31:38 -0400
Message-ID: <46798EA1.6020102@hawkeye.stone.uk.eu.org>
Date: Wed, 20 Jun 2007 21:31:29 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Spinlock init
References: <46798A37.6050007@hawkeye.stone.uk.eu.org> <ada4pl29xph.fsf@cisco.com>
In-Reply-To: <ada4pl29xph.fsf@cisco.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > can rwlock_init and spin_lock_init be used outside of functions declared
>  > __init. The spinlock documentation suggests that it can't but I'd like
>  > someone to confirm that.
> 
> Those function can be used in any function.  A function is declared
> __init if it only runs during the kernel startup, so that the memory
> holding the code for __init functions can be freed once startup is
> done.  However, spin_lock_init() is just used to initialize a freshly
> allocated spinlock, and spinlocks may be allocated at any time, even
> long after the kernel is done starting up.  A quick look throught
> kernel source code will show many, many examples where
> spin_lock_init(), rwlock_init(), mutex_init(), etc. are called from
> non-__init functions.

Exactly what I wanted to hear. Thank you very much.

Jack

