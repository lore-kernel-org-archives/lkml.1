Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab0BMXbk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 18:31:40 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:37972 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab0BMXbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 18:31:39 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B7735A7.1050305@s5r6.in-berlin.de>
Date: Sun, 14 Feb 2010 00:28:39 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Pavel Machek <pavel@ucw.cz>, "J.H." <warthog9@kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org>	<20100211205129.GA26105@elf.ucw.cz> <20100213181008.479509f5@hyperion.delvare>
In-Reply-To: <20100213181008.479509f5@hyperion.delvare>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> For my testing, I have been using the slowest machine I still have
> available here: a Pentium 166 MMX, with 64 MB of memory and a slow hard
> disk drive. I've been writing down the duration of each task it took to
> boot kernel 2.6.27.45 on this machine. I did this for both .gz and .bz2
> formats.
> 
> Raw results are as follow (format=min:s):
> 
> downloading linux-2.6.27.tar.bz2	  5:01
> downloading patch-2.6.27.45.bz2		  0:02
> unpacking linux-2.6.27.tar.bz2		  7:28
> applying patch-2.6.27.45.bz2		  1:21
> ----------------------------------------------
> total for bz2				 13:52
> 
> downloading linux-2.6.27.tar.gz		  6:23
> downloading patch-2.6.27.45.gz		  0:02
> unpacking linux-2.6.27.tar.gz		  3:20
> applying patch-2.6.27.45.gz		  1:10
> ----------------------------------------------
> total for gz				 10:55
> 
> So the gz option is unsurprisingly faster, setting up the source tree
> takes almost 3 minutes less (-21%).

If the download link had been slower than about 75 kB/s, the bz2 option
would have been faster even on this old machine.

With xz, download would be faster than bz2 and decompression would be
somewhere between bz2 and gz --- at least on machines without notable
memory constraints.  xz's decompressor is more memory hungry than
bzip2's one as far as I understand their manual pages.  But at the
default xz compressor setting of -6, the decompressor will still use
just 10 MB and should therefore not cause even your 64 MB machine to
swap all the time during decompression.

> Then the (common) build and installation times:
> 
> building				117:26
> installing modules			  0:12
> ----------------------------------------------
> total					117:38
> 
> This is a customized kernel, as small as I could do, with almost no
> features and the minimal set of drivers. As you can see, the build time
> is one order of magnitude greater than the tree setup time. Comparing
> the total times from download to install between bz2 and gz:
> 
> bz2: 13:52 + 117:38 = 131:30
> gz:  10:55 + 117:38 = 128:33
> 
> Compared to bz2, gz saves... 2% on the overall time. As a conclusion, I
> think we can plain discard the argument "I need .gz because my machine
> is slow" from now on. It simply doesn't hold.

Yep, whether the target machine is meant to compile the kernel or to be
used to browse the source code (with a bare minimum of comfort), the
hardware resources required for either task mean that there isn't such a
great difference between gz, bz2, xz WRT resource requirements at the
receivers, except that xz goes easiest on network bandwidth and disk
utilization.
-- 
Stefan Richter
-=====-==-=- --=- -==-=
http://arcgraph.de/sr/
