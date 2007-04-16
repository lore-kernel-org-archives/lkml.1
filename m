Return-Path: <linux-kernel-owner+w=401wt.eu-S1030950AbXDPUSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030950AbXDPUSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 16:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030951AbXDPUSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 16:18:48 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:43102 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030950AbXDPUSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 16:18:47 -0400
Date: Mon, 16 Apr 2007 22:18:45 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Diego Calleja <diegocg@gmail.com>
cc: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Mike Snitzer <snitzer@gmail.com>, Neil Brown <neilb@suse.de>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
In-Reply-To: <20070416210254.d619933c.diegocg@gmail.com>
Message-ID: <Pine.BSO.4.63.0704162110200.11088@rudy.mif.pg.gda.pl>
References: <op.tqqwdfzcftfxs2@localhost.localdomain> <17952.5537.364603.419364@notabene.brown>
 <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com>
 <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr>
 <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl> <46238204.9060907@s5r6.in-berlin.de>
 <Pine.BSO.4.63.0704161606280.11088@rudy.mif.pg.gda.pl> <20070416145527.GA26863@infradead.org>
 <Pine.BSO.4.63.0704161734370.11088@rudy.mif.pg.gda.pl>
 <20070416210254.d619933c.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-515844929-1176754725=:11088"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-515844929-1176754725=:11088
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 16 Apr 2007, Diego Calleja wrote:

> El Mon, 16 Apr 2007 17:46:50 +0200 (CEST), Tomasz K³oczko <kloczek@rudy.mif.pg.gda.pl> escribió:
>
>> also some other interestig numbers can be founnd on:
>> http://milek.blogspot.com/2006/08/hw-raid-vs-zfs-software-raid-part-ii.html
>
> So software raid can be faster than HW raid. News at 11.

Of cources it can be true in most cases (probably for some more advanced 
RAID controlers). Few weeks ago I perform some basic test on Dell 2950 
with 8x73GB SAS disk .. just as for kill time (waiting for access to some 
bigger box ;). This small iron box have inside RAID controller (Dell uses 
in this box LSI Logic SAS MegaRAID based ctrl). Anykind combinations on 
controler level RAID was slower than using this as plain JBOD with LVM or 
MD+LVM. Diffrence between HW and soft RAID was not so big (1-6% depending 
on configuration) but allways HW produces worser results (don't ask me 
why). Finaly I decide using this disk as four RAID1 luns only because 
under Linux I can't read each phisical disk SMART data and protecting this 
by RAID on controller level and collecting SNMP traps from DRAC card was 
kind of worakaround for this (in my case it will be better constanlty 
monitor disk healt and collesting some SMART data for observe trends on 
for example zabbix graphs for try predict some faults using triggers). On 
top of this was configured diffrent types of volumes on LVM level (some 
with stripping some without, some with bigger some with smaller chunk 
size).

But .. in case ZFS diffrences can be better visable.
Q: why ?
A: because most of HW RAID controlers (nevermind is it small/simple 
internal HW controler for DAS sotorage or advances in storage processor in 
dedicated FC array) are _optimized_ for classic FS workloads but .. ZFS 
uses bunch of devices in completly diffrent way/characteristics. If you 
will see flashing LEDs on box with disk first time configurad for classic 
RAID<any_level> (nevermind soft or hw) and on second time configured for 
ZFS you will see kind of organoleptic diffrence.
And yes .. ZFS may be kind of problem for some HW vendors ;)

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-515844929-1176754725=:11088--
