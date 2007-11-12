Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbXKLXKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbXKLXKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbXKLXKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:10:21 -0500
Received: from mx1.univ-lille1.fr ([193.49.225.19]:46243 "EHLO
	mx1.univ-lille1.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbXKLXKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:10:20 -0500
Message-ID: <4738DD3A.1080109@lifl.fr>
Date: Tue, 13 Nov 2007 00:09:46 +0100
From: Eric Piel <Eric.Piel@lifl.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.6) Gecko/20071101 Mandriva/2.0.0.6-5mdv2008.1 (2008.1) Thunderbird/2.0.0.6 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       cpufreq <cpufreq@lists.linux.org.uk>
Subject: Re: Kernel panic at boot with ondemand governor as default	(2.6.24-rc2)
References: <4737539F.2070401@lifl.fr> <1194859012.4590.595.camel@queen.suse.de> <47385D05.20705@lifl.fr> <1194880989.5474.12.camel@queen.suse.de> <20071112202629.GA31763@redhat.com>
In-Reply-To: <20071112202629.GA31763@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender DNS name whitelisted, not delayed by milter-greylist-2.0.2 (mx1.univ-lille1.fr [193.49.225.19]); Tue, 13 Nov 2007 00:09:50 +0100 (CET)
X-USTL-MailScanner-Information: Please contact the ISP for more information
X-USTL-MailScanner: Found to be clean
X-USTL-MailScanner-From: eric.piel@lifl.fr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007年11月12日 21:26, Dave Jones wrote/a écrit:
> On Mon, Nov 12, 2007 at 04:23:09PM +0100, Thomas Renninger wrote:
>  > On Mon, 2007-11-12 at 15:02 +0100, Eric Piel wrote:
:
>  > > Yes, it works if I compile speedstep-ich as module. I've put the module 
>  > > in initramfs and as soon it is loaded, the ondemand governor is selected 
>  > > and works.
>  > > 
>  > > However, do you think it's ok to prevent cpufreq drivers to be built-in 
>  > > if ondemand governor is selected as default?
>  > > Another way would be to 
>  > > reorganise the initialisation code so that workqueue is initialised 
>  > > before the cpufreq framework is started, do you think it's possible?
>  > Making all this work with low-level drivers built in would be perfect of
>  > course...
>  > If nobody answers the next days, could you open a bug at
>  > bugzilla.kernel.org, so that this does not get lost, pls.
>  > Add myself and Venkatesh to CC...
>  > I try to have a look at it ASAP.
>  > If someone already finds out more, this would be great.
> 
> I'm actually surprised that speedstep-ich works with a low enough
> latency for ondemand.  On the kernel that works, can you boot
> with cpufreq.debug=7 and send the cpufreq messages from dmesg?
I'm not surprised, contrarly to speedstep-smi, speedstep-ich has been 
working with ondemand for quite a long time, since commit 
1a10760c91c394dfe4adfefeeaf85cd8098c4894 precisely :-) As stated in the 
commit message, the latency transition is about 200µs, much smaller than 
the 10ms required by ondemand. Actually, on my laptop the transition 
time is set to even higher due to problems of measurement, but it's 
still fine for ondemand. I get this at boot:
speedstep: frequency transition measured seems out of range (4800 nSec), 
falling back to a safe one of 500000 nSec.


See you,
Eric
