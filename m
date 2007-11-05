Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbXKESKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbXKESKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbXKESKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:10:48 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59460 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbXKESKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:10:47 -0500
Date: Mon, 5 Nov 2007 13:10:46 -0500
To: "J.A. Magall?n" <jamagallon@ono.com>
Cc: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Opteron box and 4Gb memory
Message-ID: <20071105181046.GE27646@csclub.uwaterloo.ca>
References: <20071025230904.03d5f46a@werewolf> <47211172.9070606@zytor.com> <20071105001847.546565c4@werewolf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105001847.546565c4@werewolf>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 12:18:47AM +0100, J.A. Magall?n wrote:
> Well, I was able to get about 3 Gb with MTRR=discrete in the BIOS,
> but I'm still in the process to find the 'software hole' option to get
> the rest of the 4Gb...
> 
> But now another (perhaps related) question has arised...
> I like all those 5-line progams to test system performance...;).
> I just wrote a simple program that sums/muls int/float vectors with
> scalar/sse operations. And my opteron box looks terribly slow.
> 
> This is my MacPro, Xeon 5130:
> 
> belly:~/bn> bn  
> 	proc: 4 x MacPro1,1 @ 2000 MHz
> 	ram:  2048 Mb
> 	os:   unx, Darwin, 9.0.0
> 	cc:   gcc-4.0.1
> vector size   : 8 x 1024 x 1024
> allocation:     0.01 ms
> int scl add: ..........   36.78 ms,  228.07 Mips   |  114.03 Mips  /GHz
> int scl mul: ..........   34.30 ms,  244.60 Mips   |  122.30 Mips  /GHz
> flt scl add: ..........   34.28 ms,  244.73 Mflops |  122.37 Mflops/GHz
> flt vec add: ..........    7.89 ms, 1063.15 Mflops |  531.58 Mflops/GHz
> flt scl mul: ..........   34.20 ms,  245.28 Mflops |  122.64 Mflops/GHz
> flt vec mul: ..........    7.90 ms, 1061.77 Mflops |  530.89 Mflops/GHz
> total:       3322.19 ms
> 
> This is a normal (I think) opteron box (Opteron 846):
> 
> selene:~/bn> g  
> 	proc: 4 x x86_64 @ 2004 MHz
> 	ram:  3496 Mb
> 	os:   unx, Linux, 2.6.9-42.0.10.ELsmp
> 	cc:   gcc-4.0.2
> vector size   : 8 x 1024 x 1024
> allocation:     0.05 ms
> int scl add: ..........   45.98 ms,  182.42 Mips   |   91.03 Mips  /GHz
> int scl mul: ..........   44.31 ms,  189.30 Mips   |   94.46 Mips  /GHz
> flt scl add: ..........   44.52 ms,  188.41 Mflops |   94.02 Mflops/GHz
> flt vec add: ..........   10.03 ms,  836.70 Mflops |  417.52 Mflops/GHz
> flt scl mul: ..........   43.32 ms,  193.63 Mflops |   96.62 Mflops/GHz
> flt vec mul: ..........   10.02 ms,  836.98 Mflops |  417.65 Mflops/GHz
> total:       4705.07 ms
> 
> And this is my opteron (Opteron 275)
> 
> cicely:~/bn> g  
> 	proc: 4 x x86_64 @ 2200 MHz
> 	ram:  2914 Mb
> 	os:   unx, Linux, 2.6.23.1-desktop-1mdv
> 	cc:   gcc-4.0.2
> vector size   : 8 x 1024 x 1024
> allocation:     0.03 ms
> int scl add: ..........   87.67 ms,   95.68 Mips   |   43.49 Mips  /GHz
> int scl mul: ..........   85.48 ms,   98.13 Mips   |   44.61 Mips  /GHz
> flt scl add: ..........   85.90 ms,   97.66 Mflops |   44.39 Mflops/GHz
> flt vec add: ..........   19.51 ms,  429.96 Mflops |  195.44 Mflops/GHz
> flt scl mul: ..........   85.86 ms,   97.70 Mflops |   44.41 Mflops/GHz
> flt vec mul: ..........   19.50 ms,  430.11 Mflops |  195.50 Mflops/GHz
> total:       6334.96 ms
> 
> As I read in AMD site, the only difference that matters in models is
> the xx5 vx xx6, related to fequency, but the processors should be just
> the same.
> 
> As this only does intensive memory/fp operations, I'm not going to blame
> gcc nor kernel versions here (I have compared gcc 3.4, 4.0, 4.1, and 4.2
> on one of the boxes and results are very similar, the code is really
> stupid and not very suitable for compiler smartness...).
> I suspect it is a memory problem. It can be hardware or caused by
> incorrect BIOS/kernel-mtrr setup:
> 
> selene:~> cat /proc/mtrr
> reg00: base=0x00000000 (   0MB), size=16384MB: write-back, count=1
> reg01: base=0xf0000000 (3840MB), size= 256MB: uncachable, count=1
> 
> cicely:~> cat /proc/mtrr
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size= 512MB: write-back, count=1
> reg02: base=0xa0000000 (2560MB), size= 256MB: write-back, count=1
> reg03: base=0xb0000000 (2816MB), size= 128MB: write-back, count=1
> reg04: base=0xb8000000 (2944MB), size=  16MB: write-back, count=1
> 
> 
> Any idea on what can be going on here ? I have asked the 'good opteron'
> admin info about the mobo an memory of the box.
> 
> Any help will be _very_ appreciated.

Well what revisions are the two opterons?  Is one running dual channel
memory while the other isn't perhaps?  What speed and type is the ram on
the two opterons?

--
Len Sorensen
