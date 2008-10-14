Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbYJNRL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbYJNRL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 13:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYJNRLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 13:11:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:44380 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYJNRLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 13:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=usnk+BAce3YIVJzVHrpHYudtFHP+FSF+bfwJh3IleG5iGTBvmFjzqYdu22T7J1D1ah
         Js6PKNP8kaDCCouiydAlykJAJzVHEFL2RfCGv25PSZQa80orvg2Ztmst/hQv1xkFJZio
         8m1IDpEHsSkpmxpT/xryYDRASg7bRQA51BDxc=
Message-ID: <86802c440810141011w3f5774eaxf6dd02abcc87b629@mail.gmail.com>
Date: Tue, 14 Oct 2008 10:11:14 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: USB problem on x86_64: nommu_map_single() issue?
Cc: nico@chdir.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <20081014201447I.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081014104500.GB1252@sd-5945.dedibox.fr>
	 <20081014200016H.fujita.tomonori@lab.ntt.co.jp>
	 <20081014110539.GA2997@sd-5945.dedibox.fr>
	 <20081014201447I.fujita.tomonori@lab.ntt.co.jp>
X-Google-Sender-Auth: a88fcfe8b88c67e3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 4:14 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Tue, 14 Oct 2008 13:05:39 +0200
> Nicolas Bareil <nico@chdir.org> wrote:
>
>> On Tue, Oct 14, 2008 at 08:00:09PM +0900, FUJITA Tomonori wrote:
>> > > > Is this a regression? Did it work on earlier kernels?
>> > >
>> > > Yes this is a regression: USB works in 2.6.26.x with (almost) the same configuration.
>> >
>> > With old kernels, you can find something like the following line in
>> > the boot log?
>> >
>> > PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>>
>> Indeed, I have this line:
>>
>> Oct 14 12:46:29 brew kernel: [    0.004000] Calgary: detecting Calgary via BIOS EBDA area
>> Oct 14 12:46:29 brew kernel: [    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
>> Oct 14 12:46:29 brew kernel: [    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>> Oct 14 12:46:29 brew kernel: [    0.004000] Placing software IO TLB between 0x4000000 - 0x8000000
>> Oct 14 12:46:29 brew kernel: [    0.004000] Memory: 4055544k/4980736k available (2225k kernel code, 138092k reserved, 1079k data, 392k init)
>> Oct 14 12:46:29 brew kernel: [    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
>
> Probably, the changes to the initial memory setup code breaks the
> following code:
>
> void __init pci_swiotlb_init(void)
> {
>        /* don't initialize swiotlb if iommu=off (no_iommu=1) */
>        if (!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN)
>               swiotlb = 1;
>
>
> SWIOTLB should be used for your box but somehow pci-nommu is used.
>
>
>> The whole kern.log and my config are available here :
>> http://chdir.org/~nbareil/kern.log
>
> The following part in the 2.6.27 boot log looks suspicious:
>
> Oct 13 15:43:48 brew kernel: last_pfn = 0x130000 max_arch_pfn = 0x3ffffffff
that is max_pfn
> Oct 13 15:43:48 brew kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> Oct 13 15:43:48 brew kernel: last_pfn = 0xcffc2 max_arch_pfn = 0x3ffffffff
that is max_low_pfn

YH
