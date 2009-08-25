Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZHYNNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZHYNNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 09:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZHYNNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 09:13:20 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:57624 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZHYNNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:13:20 -0400
Message-ID: <4A93E36C.8070502@gmail.com>
Date: Tue, 25 Aug 2009 15:13:16 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Li_Xin2@emc.com
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: TCP keepalive timer problem
References: <0939B589FC103041945B9F13274963E303B1A9D4@CORPUSMX90A.corp.emc.com>
In-Reply-To: <0939B589FC103041945B9F13274963E303B1A9D4@CORPUSMX90A.corp.emc.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 25 Aug 2009 15:13:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li_Xin2@emc.com a écrit :
> Greetings,
> 
> I found one problem in Linux TCP keepalive timer processing, after
> searching on google, I found Daniel Stempel reported the same problem in
> 2007 (http://lkml.indiana.edu/hypermail/linux/kernel/0702.2/1136.html),
> but got no answer. So I have to reraise it.
> 
> Can anyone help answer this two-years long question?
> 
>

You should explain your problem in detail, since Daniel one was probably different.

He mentioned "(timeout is set to e.g. 30 seconds)" which is kind of nasty, given normal one is 7200

If some packets are in flight, keepalive is not fired at all, since normal
retransmits should take place (check tcp_retries2 sysctl).

TCP Keepalive is only fired when no trafic occurred for a long time, only if 
SO_KEEPALIVE socket option was enabled by application.

tcp_retries2 (integer; default: 15)
    The maximum number of times a TCP packet is retransmitted in established state
before giving up. The default value is 15, which corresponds to a duration of
approximately between 13 to 30 minutes, depending on the retransmission timeout.
The RFC 1122 specified minimum limit of 100 seconds is typically deemed too short. 

