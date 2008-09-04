Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbYIDIcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbYIDIcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYIDIcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:32:25 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:35236 "EHLO
	cs181073102.pp.htv.fi" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753905AbYIDIcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:32:24 -0400
Date: Thu, 4 Sep 2008 11:32:20 +0300
From: Markku Savela <msa@moth.iki.fi>
Message-Id: <200809040832.m848WKHh016586@burp.tkv.asdf.org>
To: linux-kernel@vger.kernel.org
Subject: How to find origin PID of a sk_buff in iptables match?
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again playing with ubuntu kernel 2.6.24.

I'm trying to write a match rule for iptables, in this case for OUTPUT
direction, and need to know the PID of the process that originates the
packet (or something).

It seems that "skb->sk->sk_peercred.pid" is always zero.

Also, I noticed that in my match code in OUTPUT chain, the current
task seemed to the originator I want (ping test). However, I'm not
quite sure whether this is always true?

If I truly wanted to associate each packet with some specific process,
what are my options?

- I expect the solution is easier for outbound packets originating
  from this host (e.g. possibly the OUTPUT chain is always executed in
  the context of the sending process?)

- for INPUT the problem is probably pretty hard to solve. I would need
  some IPTABLES rule to be run after the packet has been assinged to a
  receiving user socket and get the PID of the receiving process,
  which may be fuzzy as socket can have multiple reading processes?

ps. I did notice the iptables xt_owner match, and the comment there
saying that support for PID and SID match is not there.



