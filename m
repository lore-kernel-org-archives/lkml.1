Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbZKDAWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbZKDAWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZKDAWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:22:48 -0500
Received: from relay2.sgi.com ([192.48.179.30]:34184 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751073AbZKDAWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:22:47 -0500
Message-ID: <4AF0C958.6010103@sgi.com>
Date: Tue, 03 Nov 2009 16:22:48 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com> <87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com> <20091026215544.GA3355@basil.fritz.box> <4AEB3D95.50300@sgi.com> <4AEEBE65.3070202@linux.intel.com> <4AEF3143.2030701@sgi.com> <20091102193445.GA9948@elte.hu> <4AEF41C5.6010503@sgi.com>
In-Reply-To: <4AEF41C5.6010503@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


...
>> So please go with the simple solution i suggested days ago: print 
>> stuff on the boot CPU but after that only a single line per AP CPU.
>>
>>     Ingo
> 

Hi Ingo,

Here is some timing info I collected...  Would you accept the first
format (line per node) as a compromise?

(Note there will be 256 node systems w/4096 threads as well as
512 node systems w/HT disabled thus still 4096 threads.)

Btw, I think we should keep the processor summary as it does show some
useful information.  Agreed?  

(... I'll clean up the BogoMIPS line a bit:

	BogoMIPS(lpj):  MIN xxx (yyy)   AVG xxx (yyy)   MAX xxx (yyy)
...)

Thanks,
Mike

64 Nodes/512 cores/1024 threads...

By Node:
  1 [   27.998414] Booting Node   0, Processors 1-7,512-519
  2 [   28.645066] Booting Node   1, Processors 8-15,520-527
  3 [   29.389359] Booting Node   2, Processors 16-23,528-535
  4 [   30.160646] Booting Node   3, Processors 24-31,536-543
...
 62 [   75.013459] Booting Node  61, Processors 488-495,1000-1007
 63 [   75.789663] Booting Node  62, Processors 496-503,1008-1015
 64 [   76.565430] Booting Node  63, Processors 504-511,1016-1023
 65 [  126.860204] Brought up 1024 CPUs
 66 [  126.865392] Summary Processor Information for CPUS: 0-143,256-383,448-655,768-895,960-1023
 67 [  126.876033] Genuine Intel(R) CPU             0000 @ 2.13GHz stepping 04
 68 [  126.881404] BogoMIPS: MIN 3980.53 MAX 4268.28 AVG 4265.85
 69 [  126.888032] Loops/Jiffy: MIN 7961074 MAX 8536570 AVG 8531701
 70 [  126.896875] Summary Processor Information for CPUS: 144-239,384-447,656-751,896-959
 71 [  126.904032] Intel(R) Xeon(R) CPU           X7560  @ 2.27GHz stepping 05
 72 [  126.913404] BogoMIPS: MIN 4528.51 MAX 4762.75 AVG 4535.89
 73 [  126.920032] Loops/Jiffy: MIN 9057030 MAX 9525505 AVG 9071785
 74 [  126.924217] Summary Processor Information for CPUS: 240-255,752-767
 75 [  126.932032] Genuine Intel(R) CPU             0000 @ 2.13GHz stepping 03
 76 [  126.937404] BogoMIPS: MIN 4267.31 MAX 4268.24 AVG 4267.66
 77 [  126.944032] Loops/Jiffy: MIN 8534632 MAX 8536490 AVG 8535338
 78 [  126.952425] Total of 1024 processors activated (4454702.72 BogoMIPS).

By CPU:
   1 [   28.010255] Booting Processor 1 APIC 0x2 ip 0x6000
   2 [   28.106191] Booting Processor 2 APIC 0x4 ip 0x6000
   3 [   28.204705] Booting Processor 3 APIC 0x6 ip 0x6000
   4 [   28.300709] Booting Processor 4 APIC 0x10 ip 0x6000
   5 [   28.400707] Booting Processor 5 APIC 0x12 ip 0x6000
...
1020 [  131.440341] Booting Processor 1020 APIC 0x7f1 ip 0x6000
1021 [  131.544366] Booting Processor 1021 APIC 0x7f3 ip 0x6000
1022 [  131.648354] Booting Processor 1022 APIC 0x7f5 ip 0x6000
1023 [  131.752350] Booting Processor 1023 APIC 0x7f7 ip 0x6000
1024 [  131.852202] Brought up 1024 CPUs
1025 [  131.857394] Summary Processor Information for CPUS: 0-143,256-383,448-655,768-895,960-1023
1026 [  131.868033] Genuine Intel(R) CPU             0000 @ 2.13GHz stepping 04
1027 [  131.873404] BogoMIPS: MIN 3996.11 MAX 4555.27 AVG 4266.18
1028 [  131.880033] Loops/Jiffy: MIN 7992230 MAX 9110559 AVG 8532371
1029 [  131.888871] Summary Processor Information for CPUS: 144-239,384-447,656-751,896-959
1030 [  131.896032] Intel(R) Xeon(R) CPU           X7560  @ 2.27GHz stepping 05
1031 [  131.905405] BogoMIPS: MIN 4252.28 MAX 4819.44 AVG 4535.46
1032 [  131.912032] Loops/Jiffy: MIN 8504574 MAX 9638886 AVG 9070920
1033 [  131.916218] Summary Processor Information for CPUS: 240-255,752-767
1034 [  131.924032] Genuine Intel(R) CPU             0000 @ 2.13GHz stepping 03
1035 [  131.929404] BogoMIPS: MIN 4267.15 MAX 4268.35 AVG 4267.67
1036 [  131.936032] Loops/Jiffy: MIN 8534307 MAX 8536711 AVG 8535357
1037 [  131.944424] Total of 1024 processors activated (4454789.68 BogoMIPS).


