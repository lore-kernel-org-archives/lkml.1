Return-Path: <linux-kernel-owner+w=401wt.eu-S965687AbXDWJmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965687AbXDWJmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 05:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965692AbXDWJmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 05:42:32 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:1304 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965687AbXDWJmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 05:42:31 -0400
Date: Mon, 23 Apr 2007 11:42:54 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       Christer Weinigel <wingel@nano-system.com>,
       Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: [PATCH v3] Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070423114254.71787844@hyperion.delvare>
In-Reply-To: <20070422154151.GJ5575@csclub.uwaterloo.ca>
References: <11765554074106-git-send-email-hskinnemoen@atmel.com>
	<20070414163418.20490fe2@dhcp-252-105.norway.atmel.com>
	<20070414192807.60bdf84b@hyperion.delvare>
	<20070418174256.GB5577@csclub.uwaterloo.ca>
	<20070419085413.1520feef@hyperion.delvare>
	<20070419205942.GC5577@csclub.uwaterloo.ca>
	<20070420194933.0813a359@hyperion.delvare>
	<20070422154151.GJ5575@csclub.uwaterloo.ca>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart,

On Sun, 22 Apr 2007 11:41:51 -0400, Lennart Sorensen wrote:
> On Fri, Apr 20, 2007 at 07:49:33PM +0200, Jean Delvare wrote:
> > The scx200_acb driver was heavily modified in 2.6.17 and 2.6.18, not
> > much since then. I am not familiar with the hardware so I can't comment
> > on which chips are supposed to work and which aren't.
> 
> Well 2.6.18's scx200_acb works on the geode LX module I have, but no on
> the geode sc1200 module (where scx200_i2c does work).
> 
> scx200_acb doesn't detect any device that it can drive (nothing in dmesg
> at all when loaded) on the sc1200.

On the SCx200, the scx200_acb driver doesn't actually detect the
device. It uses arbitrary I/O addresses and hopes for the best. By
default, two buses are created, at 0x820 and 0x840. This might simply
not be the right addresses for your board. See
Documentation/i2c/busses/scx200_acb.

You should enable CONFIG_I2C_DEBUG_BUS and see what the driver says
when being loaded.

I seem to remember there has been a patch floating around to
auto-detect the right ports back in June 2006, but it seems to have
been lost somehow. Jordan, do you remember?

> I believe the main changes that
> happened to scx200_acb was adding support for the newer CSxxxx chipsets,
> such as the one used with the geode LX (which does work now).

Not only. There was also a log of bug fixing.

-- 
Jean Delvare
