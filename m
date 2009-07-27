Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZG0Nm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZG0Nm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZG0Nm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:42:27 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:51499 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbZG0Nm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:42:27 -0400
Message-ID: <4A6DAEA4.9090107@gmail.com>
Date: Mon, 27 Jul 2009 15:41:56 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jens Rosenboom <jens@mcbone.net>, Sonny Rao <sonnyrao@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: futexes: Still infinite loop in get_futex_key() in 2.6.31-rc4
References: <1248681637.7279.12.camel@fnki-nb00130>	 <1248694266.6987.1594.camel@twins>  <1248697004.7279.31.camel@fnki-nb00130>	 <1248697409.6987.1617.camel@twins>  <1248698755.7279.47.camel@fnki-nb00130> <1248701812.6987.1637.camel@twins>
In-Reply-To: <1248701812.6987.1637.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 27 Jul 2009 15:41:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra a écrit :
> On Mon, 2009-07-27 at 14:45 +0200, Jens Rosenboom wrote:
> 
>> Good question, but as this happens on a production machine, I cannot
>> easily change the installation to check this.
> 
> Uhm, but you do run .31-rc4 on it? :-)
> 
>> Attaching an strace to the process gives just
>>
>> # strace -p 12886
>> Process 12886 attached - interrupt to quit
>>
>> and nothing further.
> 
> Bugger.. how easy it is to reproduce?
> --

Strange thing is that "ps ax" doesnt use threads at all.

Stack trace seems to show mm_release() calls futex code,
but this part should not be called when a mono threaded program
exits (its clear_child_tid should be NULL at this point)


