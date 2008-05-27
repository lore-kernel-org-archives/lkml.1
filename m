Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbYE0Qo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbYE0Qo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbYE0QoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:44:17 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:46022 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbYE0QoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:44:16 -0400
Message-ID: <483C3A5A.6020207@hp.com>
Date: Tue, 27 May 2008 09:44:10 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Bill Fink <billfink@mindspring.com>
CC: =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>,
       Theodore Tso <tytso@MIT.EDU>, Glen Turner <gdt@gdt.id.au>,
       Chris Peterson <cpeterso@cpeterso.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jeff Garzik <jeff@garzik.org>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
References: <482C7E53.3050300@hp.com> <482C8184.2030906@garzik.org>	<482C8550.5000909@intel.com> <482C8D4D.3040702@garzik.org>	<20080516132107.GA11304@csclub.uwaterloo.ca>	<20080516161029.44ded734@core>	<20080516173610.GA27126@csclub.uwaterloo.ca>	<20080516191125.46f59ad6@core>	<a24804730805162155m72e6b40aweb8822515c880c50@mail.gmail.com>	<1211728189.5913.71.camel@andromache>	<20080525232712.GF5970@mit.edu> <20080526154326.1fe44214@Varda> <20080526111458.fff6c311.billfink@mindspring.com>
In-Reply-To: <20080526111458.fff6c311.billfink@mindspring.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For systems with high resolution timers, even if an attacker has total
> knowledge/control of the network, it doesn't seem realistically possible
> for them to determine the low order bits of the nanosecond timer of
> disk and network I/O system calls, if those were used as a source of
> entropy. 

Around the same time I was working on getting the performance figures 
for the RNG in the Infineon TPM in the system I had, I tried, however 
briefly, to concoct a test using netperf and pulling the ITC on an 
Itanium processor to generate some randomness.  I'm not at all sure I 
was doing things correctly - I was pulling the bottom one to 4 bits of 
the ITC after each call to recv() of a TCP_RR test - but when I tried to 
feed the resulting trickle of data through diehard (which I may have 
been running poorly) it was giving nothing but a p value of 0.000000 
which while I don't grok the p-value itself, I understand that 
consistent value of 0.000000 is bad :(

So, I may have had a bad test case.  If someone has some suggestions for 
  a better test of the low-order-bits-of-the-interval-timer hypothesis 
I'd love to hear about them.

rick jones
