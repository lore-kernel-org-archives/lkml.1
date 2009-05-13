Return-Path: <linux-kernel-owner+w=401wt.eu-S1761414AbZEMUdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414AbZEMUdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 16:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZEMUc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 16:32:59 -0400
Received: from gw.goop.org ([64.81.55.164]:36807 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZEMUc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 16:32:58 -0400
Message-ID: <4A0B2E71.1080807@goop.org>
Date: Wed, 13 May 2009 13:32:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Alex Nixon <alex.nixon@citrix.com>
Subject: Re: [PATCH 06/10] x86/PCI: Enable scanning of all pci functions
References: <1242164891-3859-1-git-send-email-jeremy@goop.org>	<1242164891-3859-7-git-send-email-jeremy@goop.org>	<20090513095535.140134e1@jbarnes-g45>	<4A0AFE84.2040805@goop.org> <20090513102316.5ef3ce4e@jbarnes-g45>
In-Reply-To: <20090513102316.5ef3ce4e@jbarnes-g45>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
>> I'd probably go the weak function path if I were to do either of
>> those, but do you think it would be significantly better?
>>     
>
> Well it would avoid the #undef, which is the gross part.  But since
> it's just a boolean, you could also do
>
> #ifndef PCI_SCAN_ALL_FNS
> #define PCI_SCAN_ALL_FNS 0
> #endif
>
> in the generic code, then just set it to 1 before asm-generic/pci.h
> gets included.  That would mean updating arch code though.
>   

If its just x86 then that's OK, but I'd prefer not to have to touch all 
arches.  Hm, doesn't look too bad.

> Anyway it's not a big deal, this code is already ugly (a 0 define for
> all arches?  why?) so you shouldn't have to spend too much time
> cleaning it up.
>   

Yes, it seems to be a vestigial thing which goes into pre-git-history.  
I think when I dug into it, I found there was one Power user of it, but 
that use evaporated in their arch unification.  But I might be 
mis-remembering.

    J

