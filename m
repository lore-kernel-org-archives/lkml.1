Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbYGDB3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbYGDB3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 21:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYGDB3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 21:29:11 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:59282 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262AbYGDB3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 21:29:10 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Miller <davem@davemloft.net>, tytso@mit.edu, jeff@garzik.org,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Date: Fri, 04 Jul 2008 11:28:32 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <6ktq649flosf8ppncg9c482j4e04097kfv@4ax.com>
References: <1215093175.10393.567.camel@pmac.infradead.org>	<20080703173040.GB30506@mit.edu>	<1215111362.10393.651.camel@pmac.infradead.org> <20080703.162120.206258339.davem@davemloft.net> <486D6DDB.4010205@infradead.org>
In-Reply-To: <486D6DDB.4010205@infradead.org>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2008 01:24:59 +0100, David Woodhouse <dwmw2@infradead.org> wrote:
...
>I'll look at making the requirement for 'make firmware_install' more 
>obvious, or even making it happen automatically as part of 
>'modules_install'.

I like this one:  Automagically part of modules_install.  No break existing 
kernel build scripts for the expected-by-user build sequence? 

And please put 'make firmware_install' into 'make help' if that's the way 
you go.  

And another point, at the moment I seem to get all sorts of odd things 
built I didn't know were there?

root@pooh:/home/grant/linux/linux-2.6.26-rc8-mm1a# make firmware_install
  HOSTCC  firmware/ihex2fw
  IHEX2FW firmware/atmsar11.fw
  INSTALL usr/lib/firmware/atmsar11.fw
  IHEX2FW firmware/dabusb/firmware.fw
  INSTALL usr/lib/firmware/dabusb/firmware.fw
  IHEX2FW firmware/emi26/loader.fw
  INSTALL usr/lib/firmware/emi26/loader.fw
  IHEX2FW firmware/emi26/firmware.fw
  INSTALL usr/lib/firmware/emi26/firmware.fw
  IHEX2FW firmware/emi26/bitstream.fw
  INSTALL usr/lib/firmware/emi26/bitstream.fw
  IHEX2FW firmware/emi62/loader.fw
  INSTALL usr/lib/firmware/emi62/loader.fw
  IHEX2FW firmware/emi62/bitstream.fw
  INSTALL usr/lib/firmware/emi62/bitstream.fw
  IHEX2FW firmware/emi62/spdif.fw
  INSTALL usr/lib/firmware/emi62/spdif.fw
  IHEX2FW firmware/emi62/midi.fw
  INSTALL usr/lib/firmware/emi62/midi.fw
  IHEX2FW firmware/keyspan/mpr.fw
  INSTALL usr/lib/firmware/keyspan/mpr.fw
  IHEX2FW firmware/keyspan/usa18x.fw
  INSTALL usr/lib/firmware/keyspan/usa18x.fw
  IHEX2FW firmware/keyspan/usa19.fw
  INSTALL usr/lib/firmware/keyspan/usa19.fw
  IHEX2FW firmware/keyspan/usa19qi.fw
  INSTALL usr/lib/firmware/keyspan/usa19qi.fw
  IHEX2FW firmware/keyspan/usa19qw.fw
  INSTALL usr/lib/firmware/keyspan/usa19qw.fw
  IHEX2FW firmware/keyspan/usa19w.fw
  INSTALL usr/lib/firmware/keyspan/usa19w.fw
  IHEX2FW firmware/keyspan/usa28.fw
  INSTALL usr/lib/firmware/keyspan/usa28.fw
  IHEX2FW firmware/keyspan/usa28xa.fw
  INSTALL usr/lib/firmware/keyspan/usa28xa.fw
  IHEX2FW firmware/keyspan/usa28xb.fw
  INSTALL usr/lib/firmware/keyspan/usa28xb.fw
  IHEX2FW firmware/keyspan/usa28x.fw
  INSTALL usr/lib/firmware/keyspan/usa28x.fw
  IHEX2FW firmware/keyspan/usa49w.fw
  INSTALL usr/lib/firmware/keyspan/usa49w.fw
  IHEX2FW firmware/keyspan/usa49wlc.fw
  INSTALL usr/lib/firmware/keyspan/usa49wlc.fw
  IHEX2FW firmware/whiteheat_loader.fw
  INSTALL usr/lib/firmware/whiteheat_loader.fw
  IHEX2FW firmware/whiteheat.fw
  INSTALL usr/lib/firmware/whiteheat.fw
  IHEX2FW firmware/keyspan_pda/keyspan_pda.fw
  INSTALL usr/lib/firmware/keyspan_pda/keyspan_pda.fw
  IHEX2FW firmware/keyspan_pda/xircom_pgs.fw
  INSTALL usr/lib/firmware/keyspan_pda/xircom_pgs.fw
  H16TOFW firmware/vicam/firmware.fw
  INSTALL usr/lib/firmware/vicam/firmware.fw

The .config and dmesg are at:
  http://bugsplatter.mine.nu/test/boxen/pooh/config-2.6.26-rc8-mm1a.gz
  http://bugsplatter.mine.nu/test/boxen/pooh/dmesg-2.6.26-rc8-mm1a.gz

Grant.
