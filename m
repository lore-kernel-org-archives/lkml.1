Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYEZORq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYEZORq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbYEZORf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:17:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43761 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbYEZORe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:17:34 -0400
Date: Mon, 26 May 2008 16:17:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Message-ID: <20080526141713.GA5771@elte.hu>
References: <20080526115628.GA31316@elte.hu> <Pine.LNX.4.64.0805261550340.16829@wrl-59.cs.helsinki.fi> <20080526135940.GB24870@elte.hu> <20080526141252.GA31352@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526141252.GA31352@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> i also ran this for 15 minutes:
> 
>   [root@europe ~]# tcpdump src and dst 10.0.1.15 -n
>   tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
>   listening on eth0, link-type EN10MB (Ethernet), capture size 96 bytes
> 
> but there was no output at all - i.e. TCP has not attempted to do 
> anything to these connections.

... which is not surprising as it traced eth0 ;-) [10.0.1.15 is the IP 
of the box and routes back to loopback]

with the proper tcpdump it gave:

[root@europe ~]# tcpdump -i lo
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on lo, link-type EN10MB (Ethernet), capture size 96 bytes
16:15:05.260000 IP europe.37198 > europe.distcc: . ack 2022529163 win 257 <nop,nop,timestamp 209526 197526>
16:15:05.260000 IP europe.distcc > europe.37198: . ack 1 win 0 <nop,nop,timestamp 209526 7020>

hm, a window of 257 and zero, is that right?

	Ingo
