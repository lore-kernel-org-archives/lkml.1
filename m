Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZHTVod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZHTVod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZHTVoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:44:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34800 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbZHTVob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:44:31 -0400
Message-ID: <4A8DC349.5060508@zytor.com>
Date: Thu, 20 Aug 2009 14:42:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Alex Chiang <achiang@hp.com>, Andi Kleen <andi@firstfloor.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
References: <20090814163618.GQ7185@ldl.fc.hp.com>	 <1250276831.3077.17.camel@sbs-t61.sc.intel.com>	 <20090814192730.GA6431@ldl.fc.hp.com>	 <1250279799.3077.41.camel@sbs-t61.sc.intel.com>	 <20090819210251.GD13061@ldl.fc.hp.com>	 <1250794594.2754.10.camel@sbs-t61.sc.intel.com>	 <20090820205425.GF13061@ldl.fc.hp.com>	 <20090820210342.GC29994@basil.fritz.box>	 <20090820212024.GG13061@ldl.fc.hp.com> <1250803577.2754.30.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1250803577.2754.30.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 02:26 PM, Suresh Siddha wrote:
> On Thu, 2009-08-20 at 14:20 -0700, Alex Chiang wrote:
>> It turns out I need to rework my patch anyway because I need to
>> think about the case where a user disables some cores in the
>> BIOS, in which case my (fragile) table selection scheme falls
>> apart.
> 
> These are the sort of reasons why we want topology detection to be
> completely based on what cpuid instruction says and nothing else.
> 

I agree... if this ID is used for topology detection, we shouldn't
replace it arbitrarily with information from BIOS just to hope that it
matches the motherboard stencil.  *Furthermore*, there is no reason why
motherboard stencilAs are purely numeric... consider the rather obvious
case of two rows of four CPUs; they may have CPU slots labelled A1, A2,
A3, A4, B1, B2, B3, B4.  It might very well be the right thing to
support arbitrary strings for platforms we recognize.

As such I think we should have a socket name field in both /proc/cpuinfo
and sysfs.

	-hpa
