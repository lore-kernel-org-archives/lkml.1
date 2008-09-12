Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYILMn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYILMn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 08:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYILMnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 08:43:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:40440 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbYILMns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 08:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,389,1217833200"; 
   d="scan'208";a="379538771"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Frans Pop <elendil@planet.nl>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Date: Fri, 12 Sep 2008 05:43:24 -0700
Subject: RE: [Bug 10843] Display artifacts on XOrg logout with PAT kernel
 and VESA framebuffer
Thread-Topic: [Bug 10843] Display artifacts on XOrg logout with PAT kernel
 and VESA framebuffer
Thread-Index: AckUxeIawdVnEh+VQaex21Hxj3kzpgADoN9w
Message-ID: <7E82351C108FA840AB1866AC776AEC462C9BAFC5@orsmsx505.amr.corp.intel.com>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
 <200806231439.00899.elendil@planet.nl>
 <20080624232252.GA24620@linux-os.sc.intel.com>
 <200809121254.02307.elendil@planet.nl>
In-Reply-To: <200809121254.02307.elendil@planet.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Frans Pop [mailto:elendil@planet.nl]
>Sent: Friday, September 12, 2008 3:54 AM
>To: Siddha, Suresh B
>Cc: Linux Kernel Mailing List; Pallipadi, Venkatesh; Ingo
>Molnar; arjan@linux.intel.com; jbarnes@virtuousgeek.org
>Subject: Re: [Bug 10843] Display artifacts on XOrg logout with
>PAT kernel and VESA framebuffer
>
>Bug-Entry  : http://bugzilla.kernel.org/show_bug.cgi?id=10843
>
>On Wednesday 25 June 2008, Suresh Siddha wrote:
>> On Mon, Jun 23, 2008 at 05:38:59AM -0700, Frans Pop wrote:
>> > On Sunday 15 June 2008, Siddha, Suresh B wrote:
>> > > Frans, With or without pat, in the recent kernels (like
>> > > 2.6.26-rc4/rc5 etc), ioremap() uses  UC- and PCI mmap of
>> > > /sys/devices/pci.../resource (used by X) uses UC-
>> > >
>> > > And fb_mmap() also uses UC-.
>> > >
>> > > It's interesting that you don't see this artifact with "nopat".
>> > > Essentially with or with out pat enabled, we use the same memory
>> > > attributes. So depending on the MTRR setup (set by X server),
>> > > effective memory attribute across different mappings
>should be same
>> > > (which is UC- or WC with mtrr).
>> >
>> > Any progress on this issue? It's still there with -rc7, but I doubt
>> > that comes as a surprise.
>> >
>> > Has anyone tried to reproduce this? I would think that should be
>> > trivial.
>> >
>> > Just as a summary:
>> > - Intel 82945G/GZ graphics [8086:2772] (ICH7 based system)
>> > - FB_VESA=y, FRAMEBUFFER_CONSOLE=y
>> > - boot with vga=791
>> > - Log in to X and KDE; I do need to really log in there are no
>> >   artifacts if I exit X from the kdm login dialog
>> > - artifacts show on logout
>> >
>>
>> FJP, We will try to reproduce this and getback.
>
>Hello all,
>
>I'd like to bring this issue to your attention once again as
>it is still
>present in 2.6.27-rc6.
>
>Note also that I can trivially reproduce exactly the same behavior on
>three rather different systems. The artifacts even look similar and in
>all cases they disappear with 'nopat'.
>
>The systems are:
>Toshiba Satellite A40 laptop:
>- Intel 82852/855GM Integrated Graphics Device [8086:3582]
>- ICH4 based
>- Mobile Intel Pentium 4 processor, i386 kernel
>Intel desktop system:
>- Intel 82945G/GZ Integrated Graphics Controller [8086:2772]
>- ICH7 based
>- Pentium D processor, x86_64 kernel
>HP Compaq 2510p laptop:
>- Intel Mobile GM965/GL960 Integrated Graphics Controller [8086:2a02]
>- ICH8 based
>- Core2 Duo processor, x86_64 kernel
>
>Have you had any luck reproducing it?
>
>> Your earlier responses did not give many clues.
>
>Well, unfortunately I can only provide the info you ask for :-)
>

Hi,

What does the output of x86/pat_memtype_list under debugfs look like?

You may need the following if you are not already mounting debugfs.
mount -t debugfs debugfs /proc/sys/debug
cat /proc/sys/debug/x86/pat_memtype_list

Thanks,
Venki
