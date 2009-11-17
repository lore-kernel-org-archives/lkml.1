Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbZKQRKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbZKQRKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbZKQRKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:10:20 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60848 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560AbZKQRKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:10:18 -0500
Date: Tue, 17 Nov 2009 12:10:23 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Matteo Croce <technoboy85@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091117171023.GG15157@caffeine.csclub.uwaterloo.ca>
References: <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca> <20091112121805.GF1394@ucw.cz> <20091113162301.GU15157@caffeine.csclub.uwaterloo.ca> <20091113165730.0b9b2676@lxorguk.ukuu.org.uk> <20091113192412.GY15157@caffeine.csclub.uwaterloo.ca> <20091113212148.5cb829d4@lxorguk.ukuu.org.uk> <20091116175006.GA15157@caffeine.csclub.uwaterloo.ca> <20091117115929.4ba23c49@lxorguk.ukuu.org.uk> <20091117143456.GF15157@caffeine.csclub.uwaterloo.ca> <4B02D2C1.2070502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B02D2C1.2070502@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 08:43:45AM -0800, H. Peter Anvin wrote:
> On 11/17/2009 06:34 AM, Lennart Sorensen wrote:
> > On Tue, Nov 17, 2009 at 11:59:29AM +0000, Alan Cox wrote:
> >>> Trying rdmsr from msr-tools 1.2 gives me:
> >>>
> >>> # ./rdmsr -x 0x00001810
> >>> rdmsr: CPU 0 cannot read MSR 0x00001810
> >>>
> >>> Hmm, now what?
> >>
> >> Beats me - I thought the region registers were read/write.
> > 
> > Actually it seems I can't read any MSRs on it.
> > 
> > Using the same kernel, same msr module, same rdmsr on a Geode LX system
> > works fine.  I can read MSRs no problem.  Seems the msr module isn't
> > working on the Geode SC1200 (and hence possibly the GX1).
> > 
> 
> That would seem highly unlikely ... unless the MSR flag isn't exposed in
> CPUID.

That would be odd yes.

# cat /proc/cpuinfo
processor       : 0
vendor_id       : CyrixInstead
cpu family      : 5
model           : 9
model name      : Geode(TM) Integrated Processor by National Semi
stepping        : 1
cpu MHz         : 266.612
cache size      : 16 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu tsc msr cx8 cmov mmx cxmmx
bogomips        : 534.41
clflush size    : 32
power management:

That part looks OK.  So why is reading MSRs not working on this stupid
CPU at any of the addresses the data book says should work.

-- 
Len Sorensen
