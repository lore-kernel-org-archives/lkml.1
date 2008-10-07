Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbYJGVep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbYJGVep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYJGVeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:34:37 -0400
Received: from gw.goop.org ([64.81.55.164]:43502 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbYJGVeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:34:36 -0400
Message-ID: <48EBD5AC.8080608@goop.org>
Date: Tue, 07 Oct 2008 14:33:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       yinghai@kernel.org
Subject: Re: [patch 3/7] x86, cpa: make the kernel physical mapping initialization
 a two pass sequence
References: <20080923210035.413932000@linux-os.sc.intel.com> <20080923211444.369122000@linux-os.sc.intel.com> <48EA798D.1090303@goop.org> <20081007015833.GO15609@linux-os.sc.intel.com> <48EB8008.1020700@goop.org> <20081007205845.GP15609@linux-os.sc.intel.com>
In-Reply-To: <20081007205845.GP15609@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Tue, Oct 07, 2008 at 08:28:08AM -0700, Jeremy Fitzhardinge wrote:
>   
>> Well, that's OK.  We just need to preserve the original page permissions
>> when fragmenting the large mappings.  (This isn't a case that affects
>> Xen, because it will already be 4k mappings.)
>>     
>
> Jeremy, Can you please check if the appended patch fixes your issue and Ack
> it? Test booted on three different 64bit platforms with and without
> DEBUG_PAGEALLOC.
>   

Will do.

>> Great.  Also, do you think you'll have a chance to look at unifying the
>> 32 and 64 bit code (where 32 uses the 64-bit version)?
>>     
>
> 32bit can't use the 64-bit version. 64bit uses large pages in the
> static mapping setup by head_64.S while the 32bit uses small mappings.
>   

The 64-bit code would obviously need a little bit of modification to 
make it work.

I don't see why 4k vs 2M initial mappings makes a difference.  32-bit 
dynamically sets up a pagetable in head.S.  The physical mapping setup 
can replace those mappings with large pages if it wants to.

Functionally both pieces of code are doing the same thing, and there's 
no reason why they couldn't be unified.

> I am also not sure why the Xen 32bit didn't break. With or with out may
> recent changes, 32bit kernel is always doing set_pte() and doesn't seem
> to care about the previous mappings. So what is special with 32bit xen
> that doesn't cause this failure. Thanks.
>   

I have a fairly sleazy hack in 32-bit Xen which means that set_pte 
doesn't override the page permissions when doing the physical mapping 
setup.  It's something I'd like to get rid of.

    J
