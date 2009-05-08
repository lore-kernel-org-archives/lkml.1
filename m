Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbZEHPI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbZEHPI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZEHPIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:08:49 -0400
Received: from gw.goop.org ([64.81.55.164]:44086 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbZEHPIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:08:49 -0400
Message-ID: <4A044B00.7060003@goop.org>
Date: Fri, 08 May 2009 08:08:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 5/8] xen/i386: make sure initial VGA/ISA mappings are
 not overridden
References: <1241727902-3176-1-git-send-email-jeremy@goop.org> <1241727902-3176-6-git-send-email-jeremy@goop.org> <20090508105728.GB11596@elte.hu>
In-Reply-To: <20090508105728.GB11596@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> arch/x86/mm/init_32.c overrides the ISA/VGA mappings with direct mappings
>> which do not have _PAGE_IOMAP set, thereby making the ISA space inaccessible.
>>
>> This patch adds to the existing hack to make sure the 
>> pre-constructed ISA mappings are not incorrectly overwritten.
>>
>> This makes 32-bit dom0 VGA work properly.
>>     
>
> I'm wondering, should we add this fix to .30 as well, is there any 
> relevancy beyond dom0?
>   

No, it only matters if the ISA region is mapping real hardware.  For 
domU we set up a set of dummy maps for ISA to mop up any stray 
references, but they have no connection to underlying hardware.

This area is all a bit ugly, and I hope to ultimately address it by 
making 32 and 64-bit use the same code for setting up the kernel 
mappings (as the 64-bit code doesn't try to double-map the ISA area).

>> Thanks to Gerd Hoffman for pointing this out.
>>     
>
> Please add Reported-by lines in such cases. That way not only does 
> the reporting get reported prominently, but the tip-bot will Cc: 
> Gerd too on the commit notification too. (which will sometimes spur 
> further comments - while a commit hidden somewhere might not)
>   

OK.  I guess Diagnosed-by: would be the most appropriate tag in this case.

>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>     
>
> Please also add impact-footers to all commits you queue up, if you 
> want me to pull your tree directly. I can only guess at the impact 
> of this one, is it:
>
> [ Impact: fix dom0-Xen-guest boot crash ]
>
> or:
>
> [ Impact: fix dom0-Xen-guest non-working VGA console ]
>
> ?
>
> (Please look at latest tip/master for examples about various impact 
> lines, their precise format, and what we try to describe in them and 
> how.)
>   

OK, they're footers now?

Do you want me to respin these patches and repost?

    J
