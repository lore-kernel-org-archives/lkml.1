Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbXLGJWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbXLGJWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 04:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbXLGJWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 04:22:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:33944 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbXLGJWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 04:22:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OLPQuqfrraGlnv8AcidhI6cdUUz4R9RoEPoNSqJuScvdzD12eDnVfCFrNaGrNEGfn5Gj53EAL37oPIVq7vJlTO8H7VkVExZRP118sLwkSXm7O2e2HjVrMIS1SWGxHrGw32r+qaKjBwcXKa4ldaptiyAq5rq6sVDQAwv4ox+Olnc=
Message-ID: <86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com>
Date: Fri, 7 Dec 2007 01:22:04 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Cc: "Vivek Goyal" <vgoyal@redhat.com>, "Neil Horman" <nhorman@tuxdriver.com>,
       "Neil Horman" <nhorman@redhat.com>, "Ben Woodard" <woodard@redhat.com>,
       "Andi Kleen" <andi@firstfloor.org>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       hbabu@us.ibm.com
In-Reply-To: <86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071127200011.GA3703@redhat.com>
	 <20071128160206.GA21286@hmsendeavour.rdu.redhat.com>
	 <20071128190525.GD3192@redhat.com> <474F7177.7050306@redhat.com>
	 <20071130144250.GC23810@redhat.com>
	 <20071130145131.GB5822@hmsendeavour.rdu.redhat.com>
	 <20071206213951.GB28898@hmsreliant.think-freely.org>
	 <20071206221143.GC2863@redhat.com>
	 <m1bq93s5r8.fsf@ebiederm.dsl.xmission.com>
	 <86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007 12:50 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Dec 6, 2007 4:33 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
...
> >
> > My feel is that if it is for legacy interrupts only it should not be a problem.
> > Let's investigate and see if we can unconditionally enable this quirk
> > for all opteron systems.
>
> i checked that bit
>
> http://www.openbios.org/viewvc/trunk/LinuxBIOSv2/src/northbridge/amd/amdk8/coherent_ht.c?revision=2596&view=markup
>
> static void enable_apic_ext_id(u8 node)
> {
> #if ENABLE_APIC_EXT_ID==1
> #warning "FIXME Is the right place to enable apic ext id here?"
>
>       u32 val;
>
>         val = pci_read_config32(NODE_HT(node), 0x68);
>         val |= (HTTC_APIC_EXT_SPUR | HTTC_APIC_EXT_ID | HTTC_APIC_EXT_BRD_CST);
>         pci_write_config32(NODE_HT(node), 0x68, val);
> #endif
> }
>
> that bit only be should be set when apic id is lifted and cpu apid is
> using 8 bits and that mean broadcast is 0xff instead 0x0f.
> for example 8 socket dual core system or 4 socket quad core
> system,that you should make BSP start from 0x04, so cpus apic id will
> be [0x04, 0x13)
>
>
> So if you want to enable that in early_quirk, you need to
> make sure apic id is using 8 bits by check if the bit 16 (HTTC_APIC_ID) is set.

it should be bit 18 (HTTC_APIC_EXT_ID)


YH
