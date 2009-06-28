Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbZF1H4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbZF1H4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 03:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZF1H4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 03:56:30 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:28150
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752651AbZF1H43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 03:56:29 -0400
Message-ID: <4A47222B.5020702@panasas.com>
Date: Sun, 28 Jun 2009 10:56:27 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       James Smart <james.smart@emulex.com>, Olaf Hering <olh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Benny Halevy <bhalevy@panasas.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
 and scsi_device_type
References: <1246122359.32198.7.camel@hpdv5.satnam>
In-Reply-To: <1246122359.32198.7.camel@hpdv5.satnam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2009 07:56:30.0639 (UTC) FILETIME=[F2880BF0:01C9F7C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2009 08:05 PM, Jaswinder Singh Rajput wrote:
> userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
> and scsi_device_type defined in kernel
> 
> fix the following 'make headers_check' warnings:
> 
>   usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
>   usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

include/scsi/scsi.h was always provided by glibc and was never exported from Kernel.
It was only recently added to include/scsi/Kbuild. (In this merge window, was never released)
(see: [9e4f5e29] [SCSI] FC Pass Thru support)

Two questions. 
1. Are we sure this will work. Is the Header fully compatible with glibc's header.
2. What will this do to distor's package managers having the same file in two packages?
   Don't we need a followup patch sent to glibc to remove that Header from there?

James Smart
  What is the new definitions needed in user-mode in scsi.h that is not available in glibc's
supplied header?

(For reference see this patch from 2007: [e629a7dd] do not export /usr/include/scsi in make headers_install)

Boaz
