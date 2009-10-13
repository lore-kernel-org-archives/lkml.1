Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbZJMOwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbZJMOwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760051AbZJMOwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:52:12 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:38876 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760048AbZJMOwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:52:11 -0400
Message-ID: <4AD493EC.9000608@gmail.com>
Date: Tue, 13 Oct 2009 16:51:24 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Craig Sanders <cas@taz.net.au>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: PROBLEM: kernel oops when tickless. 2.6.28.x to 2.6.31.3
References: <20091013090554.GB28715@taz.net.au> <4AD45169.2030507@gmail.com> <20091013141434.GA10613@taz.net.au>
In-Reply-To: <20091013141434.GA10613@taz.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 13 Oct 2009 16:51:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Craig Sanders a écrit :
> On Tue, Oct 13, 2009 at 12:07:37PM +0200, Eric Dumazet wrote:
>> This particular problem should/could be fixed in 2.6.31.4 by commit 
>> d99927f4d93f36553699573b279e0ff98ad7dea6
>> (net: Fix sock_wfree() race)
>>
>> Please try to reproduce your tickless problem on 2.6.31.4 or latest
>> Linus git tree
> 
> 
> I've already compiled 2.6.31.4 @1000HZ, but I'll compile again and try
> 2.6.31.4 tickless in the morning. i'll report back with the result - it
> usually takes a few days after booting before the Oops occurs, so if it
> goes well that might not be until the weekend or early next week.
> 
> any idea what actually triggers it?  pppoe? malformed packets from the
> internet?  udp/514 packets for rsyslogd?
> 

Oct 13 14:10:02 taz kernel: [170654.573889]  [<ffffffff81432b43>] ? sock_wfree+0x83/0x90
Oct 13 14:10:02 taz kernel: [170654.573892]  [<ffffffff814370cc>] ? skb_release_head_state+0x5c/0x110
Oct 13 14:10:02 taz kernel: [170654.573894]  [<ffffffff81436de9>] ? __kfree_skb+0x9/0xa0
Oct 13 14:10:02 taz kernel: [170654.573896]  [<ffffffff8143a48c>] ? skb_free_datagram+0xc/0x40
Oct 13 14:10:02 taz kernel: [170654.573900]  [<ffffffff814b5102>] ? unix_dgram_recvmsg+0x202/0x330

This stack trace gives a hint on sock_wfree() that was fixed in 2.6.31.4

Occurrence of the bug might be related to your PREEMPT setting.

