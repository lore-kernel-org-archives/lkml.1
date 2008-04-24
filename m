Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbYDXUq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbYDXUq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbYDXUqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:46:40 -0400
Received: from khc.piap.pl ([195.187.100.11]:38926 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbYDXUqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:46:37 -0400
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, paulkf@microgate.com, jchapman@katalix.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <m3r6cv75xq.fsf@maximus.localdomain>
	<20080424.063006.153647297.davem@davemloft.net>
	<m3mynj74nw.fsf@maximus.localdomain>
	<20080424.065555.30390704.davem@davemloft.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 24 Apr 2008 22:46:34 +0200
In-Reply-To: <20080424.065555.30390704.davem@davemloft.net> (David Miller's message of "Thu\, 24 Apr 2008 06\:55\:55 -0700 \(PDT\)")
Message-ID: <m3ve27nfpx.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> I would rather see you add small extensions to syncppp to
> provide for HDLC's needs, rather than reimplement it.

It's not about extensions, syncppp is just unmaintainable. It's
implementation of two protocols - Cisco HDLC and (sync) PPP intermixed
together.

What would be needed is a) splitting them into two files (including
protocol selection in drivers - somehow), b) replacing existing
broken syncppp state machines distributed all over the place with a
single sane state machine, c) perhaps adding IPv6, people want it,
d) packet flow from hw drivers would need to be upgraded as well
(*_type_trans() and fast path for IP/IPv6 and perhaps IPX, though
I don't know anyone ever using IPX with sync PPP).

I guess then you'd get generic HDLC.

I think it's easier to a) simply remove syncppp.c, b) apply my patch
with new PPP, c) blindly port the old drivers to generic HDLC,
d) hope for the best, with a bit of luck nobody would notice.

Alternative c) simply remove the old drivers (d) unchanged).

I don't want the breakage resulting from either action thus I think
syncppp.c should stay there (basically unchanged, though we could
at last remove those variables used only by the original FreeBSD
code in 1994).

If the new implementation is my patch or if it uses generic PPP is
debatable. I think simplicity is a good thing, the interface to
generic PPP would be bigger than the whole sync-only PPP. But I'm not
against using generic PPP, it's (AFAICS) clean and *working* and
*maintained* (and I'm not worried about backward compatibility and
certainly not about users' visions).
-- 
Krzysztof Halasa
