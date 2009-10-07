Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbZJGHoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbZJGHoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932282AbZJGHoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:44:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbZJGHoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:44:12 -0400
Message-ID: <4ACC46A2.2090103@redhat.com>
Date: Wed, 07 Oct 2009 09:43:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: Gregory Haskins <gregory.haskins@gmail.com>,
       David Howells <dhowells@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [Alacrityvm-devel] [PATCH v2 2/4] KVM: introduce "xinterface"
 API for external	interaction with guests
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net> <4AC8780D.1060800@redhat.com> <4ACA87D7.1080206@gmail.com> <4ACB0F3C.1000705@redhat.com> <4ACB46AD.8010405@gmail.com> <4ACB6E21.8010109@redhat.com> <4ACB771E.8050404@gmail.com> <20091006181859.GD6386@ovro.caltech.edu>
In-Reply-To: <20091006181859.GD6386@ovro.caltech.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2009 08:18 PM, Ira W. Snyder wrote:
>
> The limitation I have is that memory made available from the host system
> (PCI card) as PCI BAR1 must not be migrated around in memory. I can only
> change the address decoding to hit a specific physical address. AFAIK,
> this means it cannot be userspace memory (since the underlying physical
> page could change, or it could be in swap), and must be allocated with
> something like __get_free_pages() or dma_alloc_coherent().
>    

Expose it as /dev/something (/dev/mem, /sys/.../pci/...) and mmap() it, 
and it becomes non-pageable user memory.

Not sure about dma_alloc_coherent(), that is meaningless on x86.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

