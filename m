Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZC1EvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZC1EvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 00:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZC1EvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 00:51:03 -0400
Received: from smtp-out-44.synserver.de ([217.119.50.44]:1052 "HELO
	smtp-out-44.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751620AbZC1EvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 00:51:01 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 30395
Date: Sat, 28 Mar 2009 05:50:56 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:2927 tcp_ack+0xd55/0x1991()
Message-ID: <20090328045056.GA2394@gentoox2.trippelsdorf.de>
References: <20090327211202.GA10014@gentoox2.trippelsdorf.de> <Pine.LNX.4.64.0903280031080.5904@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0903280031080.5904@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 01:05:09AM +0200, Ilpo Järvinen wrote:
> On Fri, 27 Mar 2009, Markus Trippelsdorf wrote:
> 
> > I'm running the latest git kernel (2.6.29-03321-gbe0ea69) and I've got
> > this warning twice in the last few hours.:
> 
> What did you run previously?

2.6.29

> 
> > Mar 27 21:37:00 [kernel] ------------[ cut here ]------------
> > Mar 27 21:37:00 [kernel] WARNING: at net/ipv4/tcp_input.c:2927 tcp_ack+0xd55/0x1991()
> 
> This one may or may not be a new one... Starting from the point when the 
> warning was added it has been seen and some of those miscounts got tracked 
> down but there is still something remaining (and that has been the state 
> for couple of version already). It seems to require some particularly hard 
> to reproduce network behavior people usually hit once in a lifetime. 
> However, those miscount alone should not cause crashes, stalled TCP at 
> worst but even that is quite unlikely to happen if fackets_out was not 
> counted right.

The only unusual thing in my setup is that I use two Internet providers
at the same time:

# ip route show
192.168.1.0/24 dev eth1  proto kernel  scope link  src 192.168.1.2
192.168.0.0/24 dev eth0  proto kernel  scope link  src 192.168.0.2
127.0.0.0/8 via 127.0.0.1 dev lo
default equalize
        nexthop via 192.168.1.1  dev eth1 weight 10
        nexthop via 192.168.0.1  dev eth0 weight 1

> 
> > The machine hangs afterwards.
> 
> Is it really related to the warning for sure? I find it hard to 
> believe...

The machine is normally running stable for days. Switching back to 2.6.29
solves the problem...

> 
> We even fixed that miscount for you when the warning was printed out (and 
> the miscount alone wouldn't be able to cause crash anyway). Obviously 
> there could something that got broken but reading through all post 2.6.29 
> tcp material doesn't reveal anything particularly suspicious or even 
> tricky... Only one thing that is remotely related to the warning that gets 
> printed out is d3d2ae454501a4dec360995649e1b002a2ad90c5 but even that has 
> very strong foundation as it does not have any potential to introduce 
> stale references, rest of the effects would be just stalled tcp connection 
> at worst.
> 
> Please add some debugging things, at least lockdep (CONFIG_PROVE_LOCKING) 
> and soft lockup detector (CONFIG_DETECT_SOFTLOCKUP) to find out if we can 
> get some info about the actual place of hang, some other debug things 
> might also end up being useful.

Ok, will try this later today and report back. (It takes ~1 hour to
reproduce the problem with a big torrent download).

-- 
Markus
