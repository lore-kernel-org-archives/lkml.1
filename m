Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbYE3Jjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbYE3Jjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYE3Jjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:39:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47072 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751689AbYE3Jja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:39:30 -0400
Message-ID: <483FCB4E.8090104@sgi.com>
Date: Fri, 30 May 2008 11:39:26 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: benh@kernel.crashing.org, Roland Dreier <rdreier@cisco.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
Subject: Re: MMIO and gcc re-ordering issue
References: <1211852026.3286.36.camel@pasglop> <yq0iqwxrwuh.fsf@jaguar.mkp.net> <1212097223.8888.55.camel@pasglop> <200805291453.38492.jbarnes@virtuousgeek.org>
In-Reply-To: <200805291453.38492.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Thursday, May 29, 2008 2:40 pm Benjamin Herrenschmidt wrote:
>> On Thu, 2008-05-29 at 10:47 -0400, Jes Sorensen wrote:
>>> The only way to guarantee ordering in the above setup, is to either
>>> make writel() fully ordered or adding the mmiowb()'s inbetween the two
>>> writel's. On Altix you have to go and read from the PCI brige to
>>> ensure all writes to it have been flushed, which is also what mmiowb()
>>> is doing. If writel() was to guarantee this ordering, it would make
>>> every writel() call extremely expensive :-(
>> Interesting. I've always been taught by ia64 people that mmiowb() was
>> intended to be used solely between writel() and spin_unlock().
> 
> Well, that *was* true, afaik, but maybe these days multipath isn't just for 
> fail-over.  If that's true, then yeah making every single writeX ordered 
> would be the only way to go...

I could be getting bits wrong, but multi-path here is in the NUMA
routing, not at the device level.

>> If this is a performance problem, then provide relaxed variants and
>> use them in selected drivers.
> 
> Sounds reasonable.  That way drivers "just work" and important drivers can be 
> optimized.

That would kill all levels of performance in all drivers, resulting in
attempts to try and modify a fair bit of drivers to get the performance
back.

In reality this problem really only exists for devices where ordering of
consecutive writel's is a big issue. In my experience it really isn't
the case very frequently - and the number of mmiowb's that have put in
shows that too :-)

Cheers,
Jes
