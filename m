Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbZHPW6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbZHPW6J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 18:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZHPW6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 18:58:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54505 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751847AbZHPW6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 18:58:08 -0400
Date: Sun, 16 Aug 2009 23:58:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
Message-ID: <20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
In-Reply-To: <1250455590.28540.10.camel@wall-e>
References: <1250455161.28540.4.camel@wall-e>
	<1250455590.28540.10.camel@wall-e>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Aug 2009 22:46:30 +0200
Stefani Seibold <stefani@seibold.net> wrote:

> Move the pointer to the spinlock out of struct kfifo. Most
> users in tree do not actually use a spinlock, so the few
> exceptions now have to call kfifo_{get,put}_locked, which takes
> an extra argument to a spinlock.

NAK this one for the moment

We are about to set fifo loose through all the USB and some other
char/serial drivers all of which will use the spinlock facility.
