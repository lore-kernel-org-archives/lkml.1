Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbYGYPGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbYGYPGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYGYPGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:06:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50990 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930AbYGYPGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:06:04 -0400
Date: Fri, 25 Jul 2008 15:48:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: please revert commit 53f1b1433da7eac2607a4a0898a221a4485fd732
 (rtc: push the BKL down into the driver ioctl method)
Message-ID: <20080725154846.20d2cda8@lxorguk.ukuu.org.uk>
In-Reply-To: <b6a2187b0807250726n77a0cd6eqb97b817fddc343b9@mail.gmail.com>
References: <b6a2187b0807250726n77a0cd6eqb97b817fddc343b9@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 22:26:38 +0800
"Jeff Chua" <jeff.chua.linux@gmail.com> wrote:

> 53f1b1433da7eac2607a4a0898a221a4485fd732 is first bad commit
> commit 53f1b1433da7eac2607a4a0898a221a4485fd732
> Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date:   Wed Jul 23 21:30:32 2008 -0700
> 
>     rtc: push the BKL down into the driver ioctl method
> 
> 
> This commit is breaking vmware-6.0.4. Upon booting linux (guest) on
> vmware, the whole vmware environment crashed

Having reviewed the patch and the trace I believe you need to take this
up with vmware. All the patch does is slightly alter where the locking is
done. I suspect vmware are blindly calling into the rtc_fops ioctl method
directly in which case they just got burned.

One way to check this would be to add a .ioctl method back which was
simply

rtc_test_ioctl(...)
{
	printk("VMWare caught with pants down\n");
}

if it prints that instead of or while crashing you know who is guilty.

Alan
