Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbZDEHFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbZDEHFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 03:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbZDEHFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 03:05:21 -0400
Received: from newton.gmurray.org.uk ([81.2.114.237]:56860 "EHLO
	newton.gmurray.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691AbZDEHFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 03:05:20 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 newton.gmurray.org.uk n3575H0N007432
From: Graham Murray <graham@gmurray.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: Regression caused by commit "netfilter: iptables: lock free counters"
References: <20090329234702.4988017f@desktop.r000n.info>
X-Hashcash: 1:22:090405:linux-kernel@vger.kernel.org::zU8yJWbSGkqn3YEs:000000000000000000000000000000000OOJk
Date: Sun, 05 Apr 2009 08:05:17 +0100
In-Reply-To: <20090329234702.4988017f@desktop.r000n.info> (Roman Mindalev's
	message of "Sun, 29 Mar 2009 23:47:02 +0400")
Message-ID: <8763hja8cy.fsf@newton.gmurray.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Mindalev <r000n@r000n.net> writes:

> Result of the bisection:
>
> 784544739a25c30637397ace5489eeb6e15d7d49 is first bad commit
> commit 784544739a25c30637397ace5489eeb6e15d7d49             

I am seeing a different problem which also bisects to this commit. There are
no kernel messages but ip6tables fails to run.

newton ~ # ip6tables -L -v
FATAL: Module ip6_tables not found.
ip6tables v1.4.3.1: can't initialize ip6tables table `filter': Memory allocation problem
Perhaps ip6tables or your kernel needs to be upgraded.

I get this error no matter which ip6tables sub-command I run. Ip6tables
is built into the kernel, not as modules.

An strace shows the failure to be 
socket(PF_INET6, SOCK_RAW, IPPROTO_RAW) = 3
getsockopt(3, SOL_IPV6, 0x40 /* IPV6_??? */, "filter\0\305\0w~\300\0wb\305P\24\312\t\0009b\305\216\23\0\0\310\341/g\16"..., [84]) = 0
brk(0)                                  = 0x8273000
brk(0x8294000)                          = 0x8294000
getsockopt(3, SOL_IPV6, 0x41 /* IPV6_??? */, 0x8273090, 0xbfd23628) = -1 ENOMEM (Cannot allocate memory)
close(3)                                = 0

