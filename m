Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZJLHu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZJLHu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZJLHu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:50:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:52188 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZJLHuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:50:55 -0400
Message-ID: <4AD2DFA4.9000602@kernel.org>
Date: Mon, 12 Oct 2009 16:49:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Alexander Huemer <alexander.huemer@sbg.ac.at>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
References: <4ABBB8C2.2080901@sbg.ac.at> <200909251448.17671.elendil@planet.nl> <4ACDD45C.5090009@sbg.ac.at> <200910101513.51320.elendil@planet.nl>
In-Reply-To: <200910101513.51320.elendil@planet.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 07:50:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Frans Pop wrote:
>> so in my opinion reverting commit [1] with commit [2] missed the point.
>>
>> [1] a5bfc4714b3f01365aef89a92673f2ceb1ccf246
>> [2] 31b239ad1ba7225435e13f5afc47e48eb674c0cc
> 
> The most likely explanation is that your earlier test from which you
> concluded that the revert did fix the problem was incorrect. It seems
> unlikely that some other stable commit interferes here.

Hmm...

> So basically we're back where we started.
> 
>>     [ 1018.059729] irq 23: nobody cared (try booting with the "irqpoll" option)
>>     [ 1018.059734] Pid: 8656, comm: sh Tainted: G        W    2.6.31-gentoo-r2-blackbit #1
>>     [ 1018.059736] Call Trace:
>>     [ 1018.059738]  <IRQ>  [<ffffffff81066ecf>] ? __report_bad_irq+0x30/0x7d
>>     [ 1018.059748]  [<ffffffff81067023>] ? note_interrupt+0x107/0x170
>>     [ 1018.059751]  [<ffffffff81067610>] ? handle_fasteoi_irq+0x8a/0xaa
>>     [ 1018.059755]  [<ffffffff8100d1cf>] ? handle_irq+0x17/0x1d
>>     [ 1018.059757]  [<ffffffff8100c84b>] ? do_IRQ+0x54/0xb2
>>     [ 1018.059761]  [<ffffffff8100b6d3>] ? ret_from_intr+0x0/0xa
>>     [ 1018.059762]  <EOI>  [<ffffffff815c7d2c>] ? do_page_fault+0xed/0x2ef
>>     [ 1018.059769]  [<ffffffff815c7f12>] ? do_page_fault+0x2d3/0x2ef
>>     [ 1018.059773]  [<ffffffff812dd5ed>] ? __put_user_4+0x1d/0x30
>>     [ 1018.059776]  [<ffffffff815c5fdf>] ? page_fault+0x1f/0x30
>>     [ 1018.059777] handlers:
>>     [ 1018.059778] [<ffffffff813d2d8c>] (ahci_interrupt+0x0/0x426) 
>>     [ 1018.059783] Disabling IRQ #23
> 
> How reproducible is the error for you? Do you see it every time or not?
> If it is reliably reproducible, can you think of any explanation why your
> earlier test was a success while we now see that the revert does not help?
> 
> Does the error *only* occur during gcc compilation, or was that just the
> simplest way to reproduce it? Does it always occur at the same point during
> the compilation or does it vary?
> Can you create a test case that does not require doing the whole
> compilation, but only executes the step that triggers the error?
> 
> If you can find a reliable and fairly quick way to reproduce the error, I
> would suggest doing a bisection.
> 
> Jeff, Tejun: do you have any ideas what could cause this issue to suddenly
> appear or how to debug/instrument it?

Alexander, can you please attach full boot log and the output of
"lspci -nn"?  Also, how reproducible is the problem?  You already
answered to Frans' question but can you be more specific?

Thanks.

-- 
tejun
