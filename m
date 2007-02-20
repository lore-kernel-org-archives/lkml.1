Return-Path: <linux-kernel-owner+w=401wt.eu-S965170AbXBTUpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965170AbXBTUpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 15:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965153AbXBTUpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 15:45:09 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:35585 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965122AbXBTUpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 15:45:07 -0500
Date: Tue, 20 Feb 2007 21:45:05 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Josef Sipek <jsipek@fsl.cs.sunysb.edu>,
       Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: all syscalls initially taking 4usec on a P4? Re: nonblocking UDPv4 recvfrom() taking 4usec @ 3GHz?
Message-ID: <20070220204505.GB8800@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Josef Sipek <jsipek@fsl.cs.sunysb.edu>,
	Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20070219231447.GA4400@outpost.ds9a.nl> <p73d545drx6.fsf@bingen.suse.de> <20070220162714.GA3245@outpost.ds9a.nl> <20070220164124.GA24930@2ka.mipt.ru> <20070220184242.GA30077@filer.fsl.cs.sunysb.edu> <20070220184859.GA1949@2ka.mipt.ru> <20070220193319.GA8800@outpost.ds9a.nl> <20070220194040.GA18976@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220194040.GA18976@kvack.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 02:40:40PM -0500, Benjamin LaHaise wrote:

> Make sure your system is idle.  Userspace bloat means that *lots* of idle 
> activity occurs in between timer ticks on recent distributions -- all those 

You hit the nail on the head. I had previously measured with X shut down,
but the effect didn't disappear.

With init=/bin/bash, recvfrom suddenly takes from 900nsec to 1.3usec, with
only slight correlation between inter-call delay and cycles spent.

I'm investigating this further as it appears this has a real life effect on
my P4 - a drastic one!

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping        : 1
cpu MHz         : 3000.131
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
constant_tsc pni monitor ds_cpl cid xtpr
bogomips        : 6003.91
clflush size    : 64

Thanks for your help!

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
