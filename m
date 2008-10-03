Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbYJCO6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbYJCO6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYJCO5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:57:44 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:54280 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbYJCO5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:57:44 -0400
Date: Fri, 3 Oct 2008 16:57:37 +0200
From: Jan Kasprzak <kas@fi.muni.cz>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: IRQ balancing on a router
Message-ID: <20081003145737.GQ16624@fi.muni.cz>
References: <20081003132117.GM16624@fi.muni.cz> <20081003063857.76b7b61a@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081003063857.76b7b61a@linux.intel.com>
User-Agent: Mutt/1.4.2.2i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 03 Oct 2008 16:57:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
: Jan Kasprzak <kas@fi.muni.cz> wrote:
: > The result is
: > that the CPU which receives IRQs for the uplink interface
: > is 100 % busy (softirq mostly), while the other one is 90% idle.
: 
: one of the hard cases for irqbalance is that irqbalance doesn't have a
: way to find out the actual cpu time spend in the handlers. For
: networking it makes an estimate just based on the number of packets
: (which is better than nothing)... but that breaks down if you have an
: non-symmetry in CPU costs per packet like you have.
: 
: The good news is that irqthreads at least have the potential to solve
: this "lack of information"; if not, we could consider doing a form of
: microaccounting for irq handlers....

	I am not sure whether this would help. In my case, the most of the
in-kernel CPU time is not spend in the irq handler per se, but in softirq
(i.e. checking the packet against iptables rules).

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
>>  If you find yourself arguing with Alan Cox, you’re _probably_ wrong.  <<
>>     --James Morris in "How and Why You Should Become a Kernel Hacker"  <<
