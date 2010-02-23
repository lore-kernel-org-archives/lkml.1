Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0BWQ6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 11:58:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64598 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab0BWQ6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 11:58:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Neshama Parhoti <pneshama@gmail.com>
Subject: Re: sysfs vs. ioctl
Date: Tue, 23 Feb 2010 17:58:17 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <912ec82a1002230847h11d0f628rbd38b12f38270735@mail.gmail.com>
In-Reply-To: <912ec82a1002230847h11d0f628rbd38b12f38270735@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002231758.17454.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/eWwaNZLTzhqw4CPIWxVmNqPcqLYWpmPa0Mv+
 /bc5dolou9gv9c1C2ZpqHDs6MXpbs15KEPZ36V1/Jyc29fDnuE
 BdSBy3AEvtbe1+FESugXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 February 2010, Neshama Parhoti wrote:
> we are in the process of writing a new driver and we don't know
> whether to choose a sysfs or ioctl interface to user space.
> 
> we know that sysfs is preferred, but we're concerned it will have bad
> performance when compared to ioctl (our driver will have its interface
> might be used many dozens of times per second, possible even more than
> 100 times per second).
> 
> so should we opt for ioctls if a usage is expected even every 5
> miliseconds (in extreme scenarios) ?

The question is not that easy to answer generally, there are many
aspects that influence what interface to use, and sysfs is not
generally slower than ioctl either.

Can you describe what your driver is doing? One rule of thumb
is that if you already require a character device, using ioctl
is the right answer, but you shouldn't create a character device
if all you want to do over it is a single ioctl operation.

	Arnd
