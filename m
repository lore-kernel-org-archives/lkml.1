Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXEJF7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXEJF7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbXEJF7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:59:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:13031 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbXEJF7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:59:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VTk7ITd5JSUJaefDVqexX+r9PeQYRl80i4+FVuwQ9Jt3jKGkxd92GwhQm+zvEyrebujCR6qowj92/z46DcnKIMJslPRgq+yGunGwIjey+hXwwJ2uUgdG+EvBe9361sGz84h9baGg8HF6KPfJfrmS7fS25vl+TiWpyJgkqXI+hpI=
Message-ID: <ac8af0be0705092259p65f057bcoe5e1b9abb963d5e3@mail.gmail.com>
Date: Thu, 10 May 2007 13:59:35 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: discuss@x86-64.org
Subject: A question about GART aperture unmap
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following is extracted from function gart_iommu_init()
......
/*
* Unmap the IOMMU part of the GART. The alias of the page is
* always mapped with cache enabled and there is no full cache
* coherency across the GART remapping. The unmapping avoids
* automatic prefetches from the CPU allocating cache lines in
* there. All CPU accesses are done via the direct mapping to
* the backing memory. The GART address is only used by PCI
* devices.
*/
clear_kernel_mapping((unsigned long)__va(iommu_bus_base), iommu_size);
......

On my AMD-based system, the GART aperture is reserved as:
Mapping aperture over 65536 KB of RAM @ 4000000

After commenting out clear_kernel_mapping() line, the system would
have sync flood and reset from time to time. However when with this
clear_kernel_mapping() line, no system reset happened.

As we know that CPU prefetch never cross the page boundary, in this
case the page boundary is 4M. Aperture starting address is 4000000,
which is aligned with 4M. So I think CPU prefetch can not touch this
range reserved by GART aperture.

My question is: in which cases would CPU prefetch touch the address
range reserved by GART aperture?

Thanks,
Forrest
