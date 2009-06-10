Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbZFJIzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbZFJIzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbZFJIzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:55:05 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:44433 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbZFJIzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:55:03 -0400
From: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
Organization: IBM
To: michael@ellerman.id.au
Subject: Re: [PATCH 2.6.31] ehca: Tolerate dynamic memory operations and huge pages
Date: Wed, 10 Jun 2009 10:54:50 +0200
User-Agent: KMail/1.9.9
Cc: rdreier@cisco.com, alexs@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       ewg@lists.openfabrics.org, linuxppc-dev@ozlabs.org, raisch@de.ibm.com,
       ossrosch@linux.vnet.ibm.com
References: <200906091559.24661.hannes.hering@linux.vnet.ibm.com> <1244592156.4680.5.camel@concordia>
In-Reply-To: <1244592156.4680.5.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906101054.50822.hannes.hering@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Wednesday 10 June 2009 02:02:36 Michael Ellerman wrote:
> For those of us who haven't read the HEA spec lately, can you give us
> some more detail on that? :)
first of all, please note that this patch is actually for the ehca infiniband
driver. The ehca driver uses an internal memory region, which is supposed to
contain all physical memory. A memory region maps a virtually contiguous
adapter address space to the physical or better absolute address space. The
limitation is that the memory region cannot map non-contiguous virtual adapter
address space. However, on ppc64 machines there is a feature to dynamically add
or remove memory to logical partitions during runtime. These operations scatter
the absolute memory so that the kernel memory has a non-contiguous layout. This
layout cannot be represented in a memory region. The purpose of this code is to
detect the memory layout so that the memory region can be made up of the
existing memory chunks. It also translates the kernel addresses to the memory
region address, which is needed for interaction with the HCA.
> How does it interact with kexec/kdump?
We never tested the ehca driver with kexec/kdump. This patch also doesn't
improve anything in this context.

> phys_to_abs() ? As below, or does it come from somewhere else?
You're right, actually that isn't needed on System p. On the other hand I
needed to choose an address type, which is the base of all mapping. The
"busmap" holds all addresses as absolute addresses. The absolute addresses can
then be converted in any other type (virt, phys). 

Regards

Hannes

