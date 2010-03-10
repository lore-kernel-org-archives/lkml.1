Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0CJOop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:44:45 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:28391 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab0CJOom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:44:42 -0500
X-SpamScore: -34
X-BigFish: VPS-34(zz1432R98dN936eM179dN9371Pab9bhzz1202hzzz32i6bh2a8h87h43h64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KZ2MA4-01-VN9-02
X-M-MSG: 
Date: Wed, 10 Mar 2010 15:44:27 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18] KVM: MMU: Make tdp_enabled a mmu-context
 parameter
Message-ID: <20100310144426.GK5619@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
 <1267643541-451-3-git-send-email-joerg.roedel@amd.com>
 <4B94C0B5.7080507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B94C0B5.7080507@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Mar 2010 14:44:27.0323 (UTC) FILETIME=[2F1BE0B0:01CAC060]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 11:17:41AM +0200, Avi Kivity wrote:
> On 03/03/2010 09:12 PM, Joerg Roedel wrote:
> >This patch changes the tdp_enabled flag from its global
> >meaning to the mmu-context. This is necessary for Nested SVM
> >with emulation of Nested Paging where we need an extra MMU
> >context to shadow the Nested Nested Page Table.
> >
> >
> >diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >index ec891a2..e7bef19 100644
> >--- a/arch/x86/include/asm/kvm_host.h
> >+++ b/arch/x86/include/asm/kvm_host.h
> >@@ -254,6 +254,7 @@ struct kvm_mmu {
> >  	int root_level;
> >  	int shadow_root_level;
> >  	union kvm_mmu_page_role base_role;
> >+	bool tdp_enabled;
> >
> 
> This needs a different name, since the old one is still around.
> Perhaps we could call it parent_mmu and make it a kvm_mmu pointer.

Hmm, how about renaming the global tdp_enabled variable to tdp_usable?
The global variable indicates if tdp is _usable_ and we can _enable_ it
for a mmu context.

	Joerg


