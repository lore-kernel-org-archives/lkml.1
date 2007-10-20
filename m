Return-Path: <linux-kernel-owner+w=401wt.eu-S1764765AbXJTLLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764765AbXJTLLK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 07:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758109AbXJTLKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 07:10:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35467 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453AbXJTLKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:10:50 -0400
Date: Sat, 20 Oct 2007 13:10:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Valdis.Kletnieks@vt.edu
cc: Al Boldi <a1426z@gawab.com>, Bill Davidsen <davidsen@tmr.com>,
       Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFD] iptables: mangle table obsoletes filter table
In-Reply-To: <26556.1192855654@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0710201310050.1997@fbirervta.pbzchgretzou.qr>
References: <200710120031.42805.a1426z@gawab.com> <47168EA1.1080300@tmr.com>
 <471699A0.3060303@tmr.com>            <200710200640.02012.a1426z@gawab.com>
 <26556.1192855654@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 20 2007 00:47, Valdis.Kletnieks@vt.edu wrote:
>> Sure, the idea was to mark the filter table obsolete as to make people start 
>> using the mangle table to do their filtering for new setups.  The filter 
>> table would then still be available for legacy/special setups.  But this 
>> would only be possible if we at least ported the REJECT target to mangle.
>
>That's *half* the battle.  The other half is explaining why I should move
>from a perfectly functional setup that uses the filter table.  What gains
>do I get from doing so?  What isn't working that I don't know about? etc?
>
>In other words - why do I want to move from filter to mangle?

Packet processing time.
Compare previous:
	packet goes through mangle, then is dropped in filter
Compare afterwards:
	packet is already dropped in mangle

=> less code to run through
