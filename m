Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbZJHMBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbZJHMBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757854AbZJHMBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:01:14 -0400
Received: from mx17.lb01.inode.at ([62.99.145.19]:51211 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757789AbZJHMBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:01:09 -0400
Message-ID: <4ACDD45C.5090009@sbg.ac.at>
Date: Thu, 08 Oct 2009 14:00:28 +0200
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.23 (X11/20090826)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, stable@kernel.org
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
References: <4ABBB8C2.2080901@sbg.ac.at> <200909251424.25334.elendil@planet.nl> <4ABCB732.9050609@sbg.ac.at> <200909251448.17671.elendil@planet.nl>
In-Reply-To: <200909251448.17671.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Friday 25 September 2009, Alexander Huemer wrote:
>>> So with the revert already in mainline for .32, the only thing left is
>>> for that to get included in stable updates for .30 and .31.
>> please see the last comment in [1].
>> can i do anything else to help ?
>
>> [1] http://bugzilla.kernel.org/show_bug.cgi?id=14124
>
> Yes, adding that comment was excellent. I also added the relevant people
> in the CC of my previous mail, so it should get taken care of now. Unless 
> they have additional questions no further action from you should be 
> needed.
it seems like the problem is _not_ solved.
i just booted with 2.6.31.3.
2.6.31-gentoo-r2 is vanilla-2.6.31-r2 with a few unrelated patches.
did the usual verification (compilation of gcc-4.3.4),
and got this again:

    [ 1018.059729] irq 23: nobody cared (try booting with the "irqpoll"
    option)
    [ 1018.059734] Pid: 8656, comm: sh Tainted: G        W
    2.6.31-gentoo-r2-blackbit #1
    [ 1018.059736] Call Trace:
    [ 1018.059738]  <IRQ>  [<ffffffff81066ecf>] ? __report_bad_irq+0x30/0x7d
    [ 1018.059748]  [<ffffffff81067023>] ? note_interrupt+0x107/0x170
    [ 1018.059751]  [<ffffffff81067610>] ? handle_fasteoi_irq+0x8a/0xaa
    [ 1018.059755]  [<ffffffff8100d1cf>] ? handle_irq+0x17/0x1d
    [ 1018.059757]  [<ffffffff8100c84b>] ? do_IRQ+0x54/0xb2
    [ 1018.059761]  [<ffffffff8100b6d3>] ? ret_from_intr+0x0/0xa
    [ 1018.059762]  <EOI>  [<ffffffff815c7d2c>] ? do_page_fault+0xed/0x2ef
    [ 1018.059769]  [<ffffffff815c7f12>] ? do_page_fault+0x2d3/0x2ef
    [ 1018.059773]  [<ffffffff812dd5ed>] ? __put_user_4+0x1d/0x30
    [ 1018.059776]  [<ffffffff815c5fdf>] ? page_fault+0x1f/0x30
    [ 1018.059777] handlers:
    [ 1018.059778] [<ffffffff813d2d8c>] (ahci_interrupt+0x0/0x426)
    [ 1018.059783] Disabling IRQ #23

so in my opinion reverting commit [1] with commit [2] missed the point.
please comment.

-alex

[1] a5bfc4714b3f01365aef89a92673f2ceb1ccf246
[2] 31b239ad1ba7225435e13f5afc47e48eb674c0cc
