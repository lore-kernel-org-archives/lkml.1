Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYHCPKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYHCPKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 11:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbYHCPKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 11:10:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38224 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756240AbYHCPKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 11:10:40 -0400
Date: Sun, 3 Aug 2008 15:53:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux-Next <linux-next@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>, petero2@telia.com
Subject: Re: next-20080801: BUG in pktcdvd while mounting dvd
Message-ID: <20080803155320.64702b4e@lxorguk.ukuu.org.uk>
In-Reply-To: <1217765884.9907.5.camel@dhcppc0>
References: <1217765884.9907.5.camel@dhcppc0>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Aug 2008 14:18:04 +0200
Thomas Meyer <thomas@m3y3r.de> wrote:

> Greetings.
> 
> Please have a look at this bug report:
> 
> http://kerneloops.org/raw.php?rawid=47211
> 
> reverting commit 5b6155ee70e9c4d2ad7e6f514c8eee06e2711c3a fixes the
> problem

ioctl_by_bdev is calling ioctl methods with filp = NULL which is not
valid. That in turn blocks switching to unlocked_ioctl and BKL removal so
ioctl_by_bdev urgently needs fixing.

Alan
