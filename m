Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbZIYL2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbZIYL2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 07:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZIYL2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 07:28:33 -0400
Received: from mx09.lb01.inode.at ([62.99.145.9]:60364 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751069AbZIYL2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 07:28:32 -0400
Message-ID: <4ABCA95C.3060202@sbg.ac.at>
Date: Fri, 25 Sep 2009 13:28:28 +0200
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       alexander.huemer@sbg.ac.at
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
References: <4ABBB8C2.2080901@sbg.ac.at> <200909242124.42187.elendil@planet.nl> <200909242140.10174.elendil@planet.nl> <4ABC08B1.4060303@sbg.ac.at>
In-Reply-To: <4ABC08B1.4060303@sbg.ac.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Huemer wrote:
> Frans Pop wrote:
>> On Thursday 24 September 2009, Frans Pop wrote:
>>>> error message from .31:
>>>>  [157152.418524] irq 23: nobody cared
>>> If no others reply and the issue can be reproduced reliably, running a
>>> git bisect between v2.6.29 and v2.6.30 to trace the cause of the
>>> regression could be an option.
>> Looking at the changes in drivers/ata/ahci.c, it might be worth to try if 
>> reverting the following commit fixes the issue:
>>
>> commit a5bfc4714b3f01365aef89a92673f2ceb1ccf246
>> Author: Tejun Heo <tj@kernel.org>
>> Date:   Fri Jan 23 11:31:39 2009 +0900
>>
>>     ahci: drop intx manipulation on msi enable
>>
>> It's a bit of a wild guess though.
> i reproduced the issue.
>
>     [ 3486.747729] Pid: 9573, comm: jc1 Tainted: G        W 
>     2.6.31-gentoo-blackbit #2
>     [ 3486.747731] Call Trace:
>     [ 3486.747733]  <IRQ>  [<ffffffff81066e3f>] ? __report_bad_irq+0x30/0x7d
>     [ 3486.747743]  [<ffffffff81066f93>] ? note_interrupt+0x107/0x170
>     [ 3486.747746]  [<ffffffff81067580>] ? handle_fasteoi_irq+0x8a/0xaa
>     [ 3486.747750]  [<ffffffff8100d1cf>] ? handle_irq+0x17/0x1d
>     [ 3486.747752]  [<ffffffff8100c84b>] ? do_IRQ+0x54/0xb2
>     [ 3486.747756]  [<ffffffff8100b6d3>] ? ret_from_intr+0x0/0xa
>     [ 3486.747758]  <EOI>
>     [ 3486.747759] handlers:
>     [ 3486.747761] [<ffffffff813d2a6f>] (ahci_interrupt+0x0/0x426)
>     [ 3486.747765] Disabling IRQ #23
>
> i will report back after a compile run of gcc-4.3.4 with a kernel
> without the commit you suggested.
>
> -alex
4 compilation runs of gcc-4.3.4 finished without the issue re-appearing.
it seems like you guessed right, Frans.
i also found this:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=31b239ad1ba7225435e13f5afc47e48eb674c0cc
i'll report on bugzilla.

thanks for the help.
-alex
