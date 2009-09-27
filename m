Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZI0LQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZI0LQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 07:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZI0LQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 07:16:46 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:46590 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbZI0LQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 07:16:46 -0400
Message-ID: <4ABF4999.9080206@upmc.fr>
Date: Sun, 27 Sep 2009 13:16:41 +0200
From: Bernard Pidoux <bernard.pidoux@upmc.fr>
Organization: Universite Pierre & Marie Curie - Paris 6
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.1 BUG #include <asm/bitsperlong.h>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is that when I compile an application that never 
caused any problem before I get an error due to incorrect reference to <asm/bitsperlong>

This was due to int-ll64.h including <asm/bitsperlong.h> which does not exists.

Is the correct solution to replace symbolic link ?

/usr/src/linux/include/asm->asm-x86

by

/usr/src/linux/include/asm->asm-generic

Bernard Pidoux




On Sun, Sep 27, 2009 at 11:56:47AM +0200, Bernard Pidoux wrote:
> In kernel 2.6.31.1 the following files in
>
> /usr/src/linux-2.6.31.1/include/asm-generic/
>
> include <asm/bitsperlong.h> 
>
> while they should #include <asm-generic/bitsperlong.h>

It would be wrong to include the generic version
directly.
We need access to the arch specifics definitions
before we include the generic version.

See how different architectures does various things
in their: arch/$(ARCH)/include/asm/bitsperlong.h

	Sam

