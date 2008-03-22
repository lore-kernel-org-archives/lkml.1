Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbYCVEF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbYCVEF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 00:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbYCVEFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 00:05:15 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:47663 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbYCVEFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 00:05:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQAAA8i5EdBXyn6/2dsb2JhbAAIqR8
Message-ID: <47E48575.7040009@sympatico.ca>
Date: Sat, 22 Mar 2008 00:05:09 -0400
From: Allan Menezes <amenezes007@sympatico.ca>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.2) Gecko/20040804 Netscape/7.2 (ax)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: HPL benchmarking linux kernel for shared memory performance.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   Sorry to have bothered you all but there is no degradation of 
performance with hpl and kernel upto 2.6.25-rc6. It was my silly error!
The motherboards I use are two Asus p5e vm do and 3 ASus p5k-vm with 
intel Q6600 quad cpus with GO stepping oveclocking them slightly i now 
get 165 GFlops for my 5 node quad core cluster
with gotoblas v1.24 and hpl and opensource openmpi v 1.3 alpha.
My error was that the CPUID LIMIT was enabled in bios which is for older 
windows systems which prevents the cpuid instruction on boot up from 
filling the register EAX with values above 0x03
So I was seeing only 2 cores for a quad core in cat /proc/cpuinfo on all 
nodes giving me lousy performance for every kernel except some like 
2.6.23.13 and 2.6.23.14.since i was oversubscribibg each node with 4 
processes and top -H  confirmed that.
Now I disabled CPUID LIMIT for each node and i see alll 4 processors on 
eac node with cat /proc/cpuinfo for kernel ver 2.6.25-rc6 and i get 
38.44 -38.9 Gflops per node. Ofcourse i am stably overclocking each 
q6600 by approx 480mhz to get that otherwise for the kentsfiel q6600 
intel at 2.4 GHZ the peak is 38.4 GFlops( reference paper by Dr. Jack 
Dongarra et al.)
The bios message is misleading : It says " Disable for Windows Xp" and 
since I am running linux I enable it till i Googled for CPUID LIMIT and 
found out and experimented!
So for your info disable CPUID LIMIT in bios when running quad core 
linux or more! It's meant for old oses like win98 etc.
Thank you and and sorry for the bother it was my error and not a fault 
in the kernels. This is FYI only.
Cheers,
Allan Menezes
