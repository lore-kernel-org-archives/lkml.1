Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZG2OKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZG2OKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbZG2OKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:10:00 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:28985
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751581AbZG2OJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:09:59 -0400
Message-ID: <4A705831.3010002@panasas.com>
Date: Wed, 29 Jul 2009 17:09:53 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site>
In-Reply-To: <1248875763.3900.1.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jul 2009 14:09:57.0293 (UTC) FILETIME=[40BE5DD0:01CA1056]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2009 04:56 PM, James Bottomley wrote:
> On Wed, 2009-07-29 at 14:11 +0300, Michael S. Tsirkin wrote:
>> scsi/scsi.h is exported to userspace, so it should
>> use __u8 instead of u8 as other userspace-visible headers do.
> 
> Actually, can we just put a hold on this until we decide what we're
> doing with exporting include/scsi.
> 
> Arguments so far are
> 
>      1. Don't export and let glibc supply the headers (as it does now)
>      2. Move headers to be exported to include/linux
>      3. Take over include/scsi export from glibc: this will necessitate
>         comparing our current headers and those of glibc and moving
>         stuff around.
> 

I'm all for 3. I think if done we should do it for all include/scsi at once.
No need for prolonged pain.

[]$ ls /usr/include/scsi
scsi.h
scsi_ioctl.h
scsi_tgt_if.h
sg.h

However I'll have to ask my employers if they can spare me, so any other
volunteers?

TODO:
* Fix up Kernel headers by complying to check_headers
* Test drive some example user-mode applications including glibc itself.
* send patches to glibc
* send patches to Kernel
* Notify distributions.

> James
> 

Boaz
