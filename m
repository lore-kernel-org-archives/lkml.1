Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbYHYMdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbYHYMdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbYHYMdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:33:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45912 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753449AbYHYMde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:33:34 -0400
Date: Mon, 25 Aug 2008 13:16:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: Reproducible rRootage segfault with 2.6.25 and above
 (regression?)
Message-ID: <20080825131620.1d6aa87f@lxorguk.ukuu.org.uk>
In-Reply-To: <g8sncp$8us$1@ger.gmane.org>
References: <g8sncp$8us$1@ger.gmane.org>
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

> The issue is fiddly but reproducible. All help in pinpointing the 
> problem source is appreciated.

For the kernel bisect if you get stuck at a point it fails remember that
point and then lie either yes/no to it working and carry on. If need be
you can go back the other way.

Another completely off the wall guess would be that your client code is
causing gcc to generate something where it is using data which has ended
up below the stack pointer and the timings have changed. Either through
gcc bug or passing around the address of an object that is out of
context. At that point a signal will rewrite the data in fun ways
producing results like you describe.

Alan
