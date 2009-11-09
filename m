Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZKIPYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZKIPYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbZKIPYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:24:53 -0500
Received: from mail-forward1.uio.no ([129.240.10.70]:38080 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbZKIPYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:24:52 -0500
Message-ID: <4AF83444.9090208@simula.no>
Date: Mon, 09 Nov 2009 16:24:52 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       William Allen Simpson <william.allen.simpson@gmail.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "shemminger@vyatta.com" <shemminger@vyatta.com>,
       "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 1/3] net: TCP thin-stream detection
References: <f7b4caf3a5b5c906cb8d508239455322.squirrel@webmail.uio.no> <4AEB0512.4010804@nets.rwth-aachen.de> <4AF2D47F.4030701@simula.no> <alpine.DEB.2.00.0911051536200.7024@wel-95.cs.helsinki.fi>
In-Reply-To: <alpine.DEB.2.00.0911051536200.7024@wel-95.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-UiO-Ratelimit-Test: rcpts/h 18 msgs/h 3 sum rcpts/h 21 sum msgs/h 3 total rcpts 540 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: B40AAB59A7CF3568569377818CCD111B823CB0AC
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 5 total 5917 max/h 49 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo Järvinen wrote:
> On Thu, 5 Nov 2009, Andreas Petlund wrote:
> 
>> Arnd Hannemann wrote:
>>> One example: Consider standard NewReno non-SACK enabled flow:
>>> For some reasons two data packets get reordered.
>>> The TCP sender will produce a dupACK and an ACK.
>>> The dupACK will trigger (because of your logic) a spurious retransmit.
>>> The spurious retransmit will trigger a dupACK.
>>> This dupACK will again trigger a spurious retransmit.
>>> And this game will continue, unless a packet is dropped by coincidence.
>> Such an effect will be extremely rare. It will depend on the application 
>> producing an extremely even flow of packets with just the right 
>> interarrival time, and also on reordering of data (which also will 
>> happen very seldom when the number of packets in flight are so low). 
>> Even though it can happen, the data flow will progress (with spurious 
>> retransmissions). The effect will stop as soon as the application sends 
>> more than 4 segments in an RTT (which will disable the thin-stream 
>> modifications) or less than 1 (which will cause all segments to be 
>> successfully ACKed), or if, as you say, a packet is dropped.
> 
> I'd simply workaround this problem by requiring SACK to be enabled for 
> such a connection. This is reinforced by the fact that small windowed 
> transfers want it certainly to be on anyway to get the best out of ACK 
> flow even if there were some ACK losses.
> 

Thanks. I will revise the patches based on all the feedback I have gotten
and get back to the list with a new version when I have done some more
testing.

Best regards,
Andreas



