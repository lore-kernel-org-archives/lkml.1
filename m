Return-Path: <linux-kernel-owner+w=401wt.eu-S1752352AbZIJXWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbZIJXWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZIJXWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:22:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55203 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751557AbZIJXWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:22:23 -0400
Date: Fri, 11 Sep 2009 00:23:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] char/tty_io: fix legacy pty name when more than 256 pty
 devices are requested
Message-ID: <20090911002329.07d60484@lxorguk.ukuu.org.uk>
In-Reply-To: <20090910161215.5129bd71@caramujo.chehab.org>
References: <20090908144942.76ddf0e7@caramujo.chehab.org>
	<4AA6DF50.3030603@zytor.com>
	<20090908203323.486c129c@caramujo.chehab.org>
	<4AA6F63F.7090009@zytor.com>
	<20090908235441.04549a29@caramujo.chehab.org>
	<4AA73309.8030302@zytor.com>
	<20090910010512.60a1f523@caramujo.chehab.org>
	<4AA89B02.1050909@zytor.com>
	<20090910093301.4ccfd786@caramujo.chehab.org>
	<20090910150716.66310f02@lxorguk.ukuu.org.uk>
	<4AA92487.5080401@zytor.com>
	<20090910161215.5129bd71@caramujo.chehab.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the case of the BSD sockets, the patch is not just an userless fix. This is

It's useless.

> interesting when some applications are ported from other Unix'es and still uses BSD
> pty's, since several other Unix flavors were defining a higher namespace size.

They won't work because the glibc pty name handling only does the 256
devices. Given glibc still hasn't picked up tty changes from several
years ago I doubt it'll ever pick up a naming change.

BSD pty is dead. It has all sorts of problems including time taken to
find a new port being dependant on ports currently in use. The amount of
code that cares about it is close to nil, that which cares about it uses
glibc BSD pty helper code so won't work with > 256 anyway.

Alan
