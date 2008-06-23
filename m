Return-Path: <linux-kernel-owner+w=401wt.eu-S1762850AbYFWTN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762850AbYFWTN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYFWTNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:13:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:33182 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbYFWTNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oJ+qEMwY6GGtTNir+pFSzEgAYpWdAoVsAetz8QNkc265DN1iSlwfQ4h+gQhMiM9/0a
         qgKVg738r84cwJHQQh1xP61PJGUi+s/OD4W8Yj8cVpMlmvIueQ7BXht9nEoe9/VNUmSB
         QC4U0yE4BQ4QB2dtgNBV7SnmgVnI8hcS3mLwA=
Message-ID: <b1bc6a000806231213p162cea21y37ed9ec1d3bb39fd@mail.gmail.com>
Date: Mon, 23 Jun 2008 12:13:47 -0700
From: "adam radford" <aradford@gmail.com>
To: "Christopher S. Aker" <caker@theshore.net>
Subject: Re: ext3 directory corruption under Xen
Cc: linux-kernel@vger.kernel.org, "xen devel" <xen-devel@lists.xensource.com>
In-Reply-To: <485FCC25.7090401@theshore.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485FCC25.7090401@theshore.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 9:15 AM, Christopher S. Aker <caker@theshore.net> wrote:

> It's happened on a number of different hosts, all of the same hardware and
> software configuration (Xen 3.2 64bit, 32bit pae dom0, 32bit pae domUs.  LVM
> backend with 3ware hardware RAID-1).

Do you have Intel EM64T and the older 3w-xxxx driver with 4GB+ RAM?
If so there is a driver patch for older kernels to fix an issue where the driver
was over-riding the default DMA direction with DMA_BIDIRECTIONAL,
and this caused corruption going through the SWIOTLB code (not IOMMU
w/AMD).

A driver patch for older kernels including XenServer-4.1 is available here:

http://www.3ware.com/KB/article.aspx?id=15243&cNode=6I1C6S

This doesn't explain however your failures with 2.6.24 2.6.25, etc, since
this issue is no longer valid after the scsi_dma_map() changes that went
into most scsi drivers since 2.6.23.

-Adam
