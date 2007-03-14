Return-Path: <linux-kernel-owner+w=401wt.eu-S1161326AbXCNOok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161326AbXCNOok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 10:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161325AbXCNOok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 10:44:40 -0400
Received: from web36706.mail.mud.yahoo.com ([209.191.85.40]:48205 "HELO
	web36706.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161314AbXCNOoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 10:44:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=S/eUT+ydnW+ViisD9T8w3a5CdQou4XUiZpXgHH6pIzJW7OHB1+x37P695jJvEWETD1ojps/Kubz8A0sIrvXC18bOeX7LCbJMwWbwV9mtIcP83xdDFubb7wUCUzsv8ZSwzifAFj72aCvhd3TAbkCObe3jaKzggV5KJON1ti6paZ4=  ;
Message-ID: <20070314144437.3695.qmail@web36706.mail.mud.yahoo.com>
X-YMail-OSG: DrzKUL0VM1l8yap7pBJLyDdJ74hyk4JYGvIzx8jqX.wqrqMlm6_SA14H0Se2ol9nBwRgPwVXbEqSzeJRcXmScrPnAoWWrJWjMKoYaK8YeLQXoMkpY2fiP8OaHpLTVsotvhGN3ltUCDsvnBUVaBU8Vg5jgg--
Date: Wed, 14 Mar 2007 07:44:37 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Weird MMC errors: 1 of 2 - bad ocr value
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D9995F.9070108@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, I've obtained a bug report concerning an MMC card. Two problems are described, both
sporadic.
Problem 1: illegal ocr value is returned. You may notice, in the non-working case, obviously
incorrect ocr value (0xffffffff) is returned. The card won't work after this, unless reinserted.
What, to your opinion, shall we do about it?

---- Normal case - everything works: ----------
Mar 14 09:15:39 Tirion kernel: mmc0: starting CMD1 arg 00300000 flags 00000061
Mar 14 09:15:39 Tirion kernel: tifm_sd tifm_sd0:1: executing opcode 0x1, arg: 0x300000, mask: 
0x1340
Mar 14 09:15:39 Tirion kernel: tifm_sd tifm_sd0:1: host event: host_status 1001, flags 0
Mar 14 09:15:39 Tirion kernel: mmc0: req done (CMD1): 0/0/0: 00ff8000 00000000 00000000 00000000
Mar 14 09:15:39 Tirion kernel: mmc0: starting CMD1 arg 00300000 flags 00000061
Mar 14 09:15:39 Tirion kernel: tifm_sd tifm_sd0:1: executing opcode 0x1, arg: 0x300000, mask: 
0x1340
Mar 14 09:15:39 Tirion kernel: tifm_sd tifm_sd0:1: host event: host_status 1001, flags 0
Mar 14 09:15:39 Tirion kernel: mmc0: req done (CMD1): 0/0/0: 00ff8000 00000000 00000000 00000000
Mar 14 09:15:39 Tirion kernel: mmc0: starting CMD1 arg 00300000 flags 00000061
Mar 14 09:15:39 Tirion kernel: tifm_sd tifm_sd0:1: executing opcode 0x1, arg: 0x300000, mask: 
0x1340
Mar 14 09:15:39 Tirion kernel: tifm_sd tifm_sd0:1: host event: host_status 1, flags 0
Mar 14 09:15:39 Tirion kernel: mmc0: req done (CMD1): 0/0/0: 80ff8000 00000000 00000000 00000000
Mar 14 09:15:39 Tirion kernel: mmc0: starting CMD2 arg 00000000 flags 00000067
Mar 14 09:15:39 Tirion kernel: tifm_sd tifm_sd0:1: executing opcode 0x2, arg: 0x0, mask: 0x1240
Mar 14 09:15:39 Tirion kernel: tifm_sd tifm_sd0:1: host event: host_status 1, flags 0
Mar 14 09:15:39 Tirion kernel: mmc0: req done (CMD2): 0/0/0: 06000131 364d2020 20011d43 332479ad
-------------------


------- Error case: OCR value is bad, card is left in bad state and won't work: ---------
Mar 14 09:15:24 Tirion kernel: mmc0: starting CMD1 arg 00300000 flags 00000061
Mar 14 09:15:24 Tirion kernel: tifm_sd tifm_sd0:1: executing opcode 0x1, arg: 0x300000, mask: 
0x1340
Mar 14 09:15:24 Tirion kernel: tifm_sd tifm_sd0:1: host event: host_status 1001, flags 0
Mar 14 09:15:24 Tirion kernel: mmc0: req done (CMD1): 0/0/0: 00ff8000 00000000 00000000 00000000
Mar 14 09:15:24 Tirion kernel: mmc0: starting CMD1 arg 00300000 flags 00000061
Mar 14 09:15:24 Tirion kernel: tifm_sd tifm_sd0:1: executing opcode 0x1, arg: 0x300000, mask: 
0x1340
Mar 14 09:15:24 Tirion kernel: tifm_sd tifm_sd0:1: host event: host_status 1, flags 0
Mar 14 09:15:24 Tirion kernel: mmc0: req done (CMD1): 0/0/0: ffffffff 00000000 00000000 00000000
Mar 14 09:15:24 Tirion kernel: mmc0: starting CMD2 arg 00000000 flags 00000067
Mar 14 09:15:24 Tirion kernel: tifm_sd tifm_sd0:1: executing opcode 0x2, arg: 0x0, mask: 0x1240
Mar 14 09:15:24 Tirion kernel: tifm_sd tifm_sd0:1: host event: host_status 80, flags 0
Mar 14 09:15:24 Tirion kernel: mmc0: req done (CMD2): 1/0/0: 00000000 00000000 00000000 00000000
---------------------


 
____________________________________________________________________________________
Don't get soaked.  Take a quick peek at the forecast
with the Yahoo! Search weather shortcut.
http://tools.search.yahoo.com/shortcuts/#loc_weather
