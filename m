Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZCQGFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZCQGFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 02:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZCQGFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 02:05:44 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:36005 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752762AbZCQGFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 02:05:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LHrW3spm1MOm368GZjbUtAPYKnphKo+FKinIcHGoJXMe3l9485to3/UiASe6hdeTsIwhYEiwkFL4svOdxjuCuLugx0x5Fv87bHiuHPikMA0Nz31GHrSGEqkBlzircwQAJ6vb/R8RMmxU0/85mXI836I5Ug8PZesNZ9hgA7g/uDY=  ;
X-YMail-OSG: 8AzkpmcVM1n5ANkGcrawHmeL1kac90I1hVNVn9VX4pQHwEzDFJwV8vByqGwDAgnHBZIrJwVkI0Sn0fVQFfaHHnrl5hvVcSp2iG9qouYqiozE0MGUPMGKoK5tP3unL71MIr3Dc29v4KmmcVaa1itD17B8s9DSUhqpFEqwL6_B8TTd5lRKb29ZiKnTo2WfwA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: cli/sti vs local_cmpxchg and local_add_return
Date: Tue, 17 Mar 2009 17:05:35 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
References: <20090317013220.GA22474@Krystal>
In-Reply-To: <20090317013220.GA22474@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903171705.35599.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 March 2009 12:32:20 Mathieu Desnoyers wrote:
> Hi,
>
> I am trying to get access to some non-x86 hardware to run some atomic
> primitive benchmarks for a paper on LTTng I am preparing. That should be
> useful to argue about performance benefit of per-cpu atomic operations
> vs interrupt disabling. I would like to run the following benchmark
> module on CONFIG_SMP :
>
> - PowerPC
> - MIPS
> - ia64
> - alpha
>
> usage :
> make
> insmod test-cmpxchg-nolock.ko
> insmod: error inserting 'test-cmpxchg-nolock.ko': -1 Resource temporarily
> unavailable dmesg (see dmesg output)
>
> If some of you would be kind enough to run my test module provided below
> and provide the results of these tests on a recent kernel (2.6.26~2.6.29
> should be good) along with their cpuinfo, I would greatly appreciate.
>
> Here are the CAS results for various Intel-based architectures :
>
> Architecture         | Speedup                      |      CAS     |       
>  Interrupts         |
>
>                      | (cli + sti) / local cmpxchg  | local | sync | Enable
>                      | (sti) | Disable (cli)
>
> ---------------------------------------------------------------------------
>---------------------- Intel Pentium 4      | 5.24                         |
>  25   | 81   | 70           | 61          | AMD Athlon(tm)64 X2  | 4.57    
>                     |  7    | 17   | 17           | 15          | Intel
> Core2          | 6.33                         |  6    | 30   | 20          
> | 18          | Intel Xeon E5405     | 5.25                         |  8   
> | 24   | 20           | 22          |
>
> The benefit expected on PowerPC, ia64 and alpha should principally come
> from removed memory barriers in the local primitives.

Benefit versus what? I think all of those architectures can do SMP
atomic compare exchange sequences without barriers, can't they?

