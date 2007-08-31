Return-Path: <linux-kernel-owner+w=401wt.eu-S965483AbXHaOVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965483AbXHaOVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965155AbXHaOV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:21:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965154AbXHaOV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:21:26 -0400
Message-ID: <46D823C0.5040309@zytor.com>
Date: Fri, 31 Aug 2007 07:20:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Christian Ehrhardt <lk@c--e.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: New x86-Setup code breaks HVM-XEN boot
References: <20070830141528.GA307@lisa.in-ulm.de> <46D714A9.4060103@goop.org> <20070831075434.GF20195@genua.de>
In-Reply-To: <20070831075434.GF20195@genua.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Ehrhardt wrote:
> (XEN) Failed vm entry (exit reason 0x80000021) caused by invalid guest state (0).
> (XEN) ************* VMCS Area **************
> (XEN) 	 16-bit Guest-State Fields
> (XEN) 		0x00000800: 0x0018 0x0010 0x0018 0x0018 
> (XEN) 		0x00000808: 0x0018 0x0018 0x0000 0x0008 
> (XEN) 	 16-bit Host-State Fields
> (XEN) 		0x00000c00: 0xe010 0xe008 0xe010 0xe010 
> (XEN) 		0x00000c08: 0xe010 0xe010 0xe050 
> (XEN) 	 64-bit Control Fields
> (XEN) 		0x00002000: 0x0000000000bd5000 0x0000000000000000 0x0000000000bd4000 0x0000000000000000 
> (XEN) 		0x00002004: 0x0000000000000000 0x0000000000000000 0x0000000000000000 0x0000000000000000 
> (XEN) 		0x00002008: 0x0000000000000000 0x0000000000000000 0x0000000000000000 0x0000000000000000 
> (XEN) 		0x0000200c: 0x0000000000000000 0x0000000000000000 ------------------ ------------------ 
> (XEN) 		0x00002010: 0x00000000d8ba12e5 0x00000000ffd5e176 0x0000000000000000 0x0000000000000000 
> (XEN) 	 64-bit Guest-State Fields
> (XEN) 		0x00002800: 0x00000000ffffffff 0x00000000ffffffff 0x0000000000000000 0x0000000000000000 
> (XEN) 	 32-bit Control Fields
> (XEN) 		0x00004000: 0x0000001f 0x0681e7fa 0x00004008 0x00000000 
> (XEN) 		0x00004008: 0x00000000 0x00000000 0x0003edff 0x00000000 
> (XEN) 		0x00004010: 0x00000000 0x000011ff 0x00000000 0x00000020 
> (XEN) 		0x00004018: 0x00000000 0x00000000 0x00000000 
> (XEN) 	 32-bit RO Data Fields
> (XEN) 		0x00004400: 0x0000000c 0x80000021 0x00000000 0x00050033 
> (XEN) 		0x00004408: 0x00000000 0x00000000 0x00000003 0x00000000 
> (XEN) 	 32-bit Guest-State Fields
> (XEN) 		0x00004800: 0xffffffff 0xffffffff 0xffffffff 0xffffffff 
> (XEN) 		0x00004808: 0xffffffff 0xffffffff 0x00000000 0x00002067 
> (XEN) 		0x00004810: 0x00006fb5 0x00000000 0x0000d0ff 0x0000d0ff 
> (XEN) 		0x00004818: 0x0000d0ff 0x0000d0ff 0x0000d0ff 0x0000d0ff 
> (XEN) 		0x00004820: 0x00000082 0x0000008b 0x00000000 0x00000000 
> (XEN) 		0x00004828: 0x00000000 0x00000000 
> (XEN) 	 32-bit Host-State Fields
> (XEN) 		0x00004c00: 0x00000000 
> (XEN) 	 Natural 64-bit Control Fields
> (XEN) 		0x00006000: 0x00000000ffffffff 0x00000000ffffffff 0x0000000000050033 0x0000000000000651 
> (XEN) 		0x00006008: 0x0000000000000000 0x0000000000000000 0x0000000000000000 0x0000000000000000 
> (XEN) 	 64-bit RO Data Fields
> (XEN) 		0x00006400: 0x0000000000000000 0x0000000000010002 0x00000000003f7fd5 0x00000000001a2000 
> (XEN) 		0x00006408: 0x00000000000d11b2 0x0000000000000000 
> (XEN) 	 Natural 64-bit Guest-State Fields
> (XEN) 		0x00006800: 0x0000000080050033 0x0000000000bbfda0 0x0000000000002671 0x00000000ffffffff 
> (XEN) 		0x00006808: 0x00000000ffffffff 0x00000000ffffffff 0x00000000ffffffff 0x00000000ffffffff 
> (XEN) 		0x00006810: 0x00000000ffffffff 0x0000000000000000 0x00000000000d7264 0x00000000190df0bc 
> (XEN) 		0x00006818: 0x0000000000000000 0x0000000000000400 0x000000000000f9e8 0x0000000000100000 
> (XEN) 		0x00006820: 0x0000000000010002 0x0000000000000000 0x0000000000000000 0x0000000000000000 
> (XEN) 	 Natural 64-bit Host-State Fields
> (XEN) 		0x00006c00: 0x000000008005003b 0x00000000a1f47000 0x00000000000026f0 0x0000000000000000 
> (XEN) 		0x00006c08: 0x0000000000000000 0x00000000ff1cf380 0x00000000fe800000 0x00000000ffbeb080 
> (XEN) 		0x00006c10: 0x0000000000000000 0x0000000000000000 0x00000000ffbf3fe8 0x00000000ff14ab10 
> (XEN) **************************************
> (XEN) domain_crash_sync called from vmx.c:2154
> (XEN) Domain 353 (vcpu#0) crashed on cpu#1:
> (XEN) ----[ Xen-3.0.3-1  x86_32p  debug=n  Not tainted ]----
> (XEN) CPU:    1
> (XEN) EIP:    0010:[<00100000>]
> (XEN) EFLAGS: 00010002   CONTEXT: hvm
> (XEN) eax: 00100000   ebx: 00000000   ecx: f0000018   edx: 00050013
> (XEN) esi: 000932a0   edi: 000042d0   ebp: 000d0000   esp: 0000f9e8
> (XEN) cr0: 00050033   cr4: 00000651   cr3: 00bbfda0   cr2: 00000000
> (XEN) ds: 0018   es: 0018   fs: 0018   gs: 0018   ss: 0018   cs: 0010
> 

Xen crashes because it thinks VMX should be handling this, but VMX 
doesn't think so (the exit reason is "invalid state".)

At this point, paging is not yet enabled (CR0.PG = 0), but that is not 
natively supported by VMX.  From a cursory look it doesn't appear as 
though that Xen has recognized that it's supposed to emulate this in one 
way or another.

I'm on the road, so I don't have time for a more detailed analysis just 
at the moment.

	-hpa
