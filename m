Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYGQFiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYGQFiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 01:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYGQFio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 01:38:44 -0400
Received: from il.qumranet.com ([212.179.150.194]:43931 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbYGQFin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 01:38:43 -0400
Message-ID: <487EDAE1.8050007@qumranet.com>
Date: Thu, 17 Jul 2008 08:38:41 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
Subject: Re: kvm causing memory corruption?  now 2.6.26
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>	 <47EA1C63.8010202@qumranet.com>	 <1206550329.7883.5.camel@nimitz.home.sr71.net>	 <47EA80AC.4070204@qumranet.com>	 <1206551794.7883.7.camel@nimitz.home.sr71.net>	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>	 <1206629709.7883.30.camel@nimitz.home.sr71.net>	 <47EBB63E.2060306@qumranet.com>	 <1212445810.8211.9.camel@nimitz.home.sr71.net>	 <48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>	 <48512028.3070104@qumranet.com>  <1216148242.25942.6.camel@nimitz> <1216244660.8711.6.camel@nimitz>
In-Reply-To: <1216244660.8711.6.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On a suggestion of Anthony's, I tried a defconfig kernel.
>
> It is now bombing out on an assertion in the lapic code:
>
> 	http://sr71.net/~dave/linux/2.6.26-oops1.txt
>
>
>   

Well that assert is plain wrong:

static int apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
               int short_hand, int dest, int dest_mode)
{
    int result = 0;
    struct kvm_lapic *target = vcpu->arch.apic;

    apic_debug("target %p, source %p, dest 0x%x, "
           "dest_mode 0x%x, short_hand 0x%x",
           target, source, dest, dest_mode, short_hand);

    ASSERT(!target);


It should be ASSERT(target), if anything.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

