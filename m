Return-Path: <linux-kernel-owner+w=401wt.eu-S1751543AbZLVKK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbZLVKK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 05:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbZLVKKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 05:10:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:53195 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbZLVKKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 05:10:54 -0500
Message-ID: <4B309AB9.7030208@kernel.org>
Date: Tue, 22 Dec 2009 02:08:57 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [git pull request] ACPI and driver patches for 2.6.33.merge
References: <alpine.LFD.2.00.0912161453480.10371@localhost.localdomain> <86802c440912171728s27dd7108k85a0f1563660c95b@mail.gmail.com> <20091218022112.GA30333@sli10-desk.sh.intel.com> <20091218051457.GB417@elte.hu>
In-Reply-To: <20091218051457.GB417@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Shaohua Li <shaohua.li@intel.com> wrote:
> 
>> On Fri, Dec 18, 2009 at 09:28:50AM +0800, Yinghai Lu wrote:
>>> On Wed, Dec 16, 2009 at 12:06 PM, Len Brown <lenb@kernel.org> wrote:
>>>> Hi Linus,
>>>>
>>>> please pull from:
>>>>
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
>>>>
>>> ;..
>>>> Shaohua Li (3):
>>>> ? ? ?ACPI: Add a generic API for _OSC -v2
>>>> ? ? ?ACPI: cleanup pci_root _OSC code.
>>>> ? ? ?ACPI: Add platform-wide _OSC support.
>>> it seems these three patches broke the _OSC on my intel new systems.
>>>
>>> revert them fix the problem with AER and pciehp and etc
>> can you give more details? I just cleaned up the _OSC code for AER and 
>> pciehp, no function changes.
> 
> Famous last words ;-)
> 
> Yinghai, i suspect Shaohua needs the kind of info you'd need if you tried to 
> fix it: acpidump, before/after debug boot log, a description of what goes bad, 
> etc.

the so called clean up, change the ret length checking.

-       if (!output.length)
-               return AE_NULL_OBJECT;
-

+       /* return buffer should have the same length as cap buffer */
+       if (context->ret.length != context->cap.length)
+               return AE_NULL_OBJECT;

YH
