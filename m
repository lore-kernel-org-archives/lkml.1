Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbXHWX2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbXHWX2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932952AbXHWX12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:27:28 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:62333 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963AbXHWX1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:27:23 -0400
Date: Thu, 23 Aug 2007 17:27:07 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: intel_rng: FWH not detected (and no entropy)
In-reply-to: <fa.bebINmq7qS5j+XUn0INfBmoRKMo@ifi.uio.no>
To: Pierre Chifflier <p.chifflier@inl.fr>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org
Message-id: <46CE17CB.10302@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.htD9D53DODI/2aOgxkVH8l7syew@ifi.uio.no>
 <fa.2v4wVrqxU4LJuuB/0Pes0Aw5CoY@ifi.uio.no>
 <fa.bebINmq7qS5j+XUn0INfBmoRKMo@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Chifflier wrote:
> On Thu, Aug 23, 2007 at 09:53:04AM -0300, Henrique de Moraes Holschuh wrote:
>> On Thu, 23 Aug 2007, Pierre Chifflier wrote:
>>> I'm not sure the mhat a hardware RNG is present, so I want to check.
>> Open the mobo, and locate all FLASH chips.  If one of them is a 82802AB or
>> 82802AC, then you *MIGHT* have an Intel FWH with a HRNG (some of the FWHs
>> have their RNGs disabled, and since Intel stopped guaranteeing the RNG is
>> there, they would install one such FWH in their boards just the same).  If
>> none are a 82802AB or 82802AC, you don't have an Intel FWH with a HRNG.
>>
>> Even if you had an Intel board that is known to sometimes have an Intel FWH
>> with an RNG, like the D875PBZ, that wouldn't mean much.  They could have
>> used an non-Intel equivalent part for that production run, for unknown
>> reasons.  You really have to check.
> 
> Well, I've seen nothing more than the 82801DB (which was listed in
> lspci). So maybe there is no HRNG :(
> 
> This leaves the main problem, which is the lack of entropy. Does anyone
> have an idea on how to solve this problem ?
> It appeared with recent kernels. For ex, 2.6.8 had an entropy pool
> always > 3000, while 2.6.18 and other recent kernels show ~ 150.
> 
> # sysctl kernel.random.poolsize
> kernel.random.poolsize = 4096
> # sysctl kernel.random.entropy_avail
> kernel.random.entropy_avail = 196
> 
> This is really annoying, since the box should also use SSL/TLS
> operations, and it will be real slow ..

I believe that the timing of network interrupts used to be used to 
provide entropy, however in later kernels this was taken out as it was 
thought unsafe, since an attacker could detect or control the timing of 
these packets and thus determine the contents of the entropy pool.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

