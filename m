Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZG0IhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZG0IhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 04:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbZG0IhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 04:37:23 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:17382
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750767AbZG0IhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 04:37:22 -0400
Message-ID: <4A6D6740.5040005@panasas.com>
Date: Mon, 27 Jul 2009 11:37:20 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Don't export scsi kernel variables in userspace	headers.
References: <20090725021026.GA6942@redhat.com> <20090727074418.GA14765@infradead.org> <20090727082623.GA18747@merkur.ravnborg.org>
In-Reply-To: <20090727082623.GA18747@merkur.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jul 2009 08:37:22.0783 (UTC) FILETIME=[761A46F0:01CA0E95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2009 11:26 AM, Sam Ravnborg wrote:
> On Mon, Jul 27, 2009 at 03:44:18AM -0400, Christoph Hellwig wrote:
>> On Fri, Jul 24, 2009 at 10:10:26PM -0400, Dave Jones wrote:
>>> Found with make headers_check
>>>
>>> /usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
>>> /usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel
>> The headers shouldn't be exported at all because scsi/ headers are
>> exported from glibc.
> Where does glibc get these headers from?
> 
> If glibc have their own private copy then the headers should indeed be exported
> so we avoid such mess.
> 
> 	Sam

We never had a Kbuild file in include/scsi. It was only added recently by the fcoe patchset.
scsi.h is not the only problem. All of /usr/include/scsi/* come from glibc private snapshot.

I agree with Sam that this is a complete mess, and that Kernel should take control back.
But someone should do it in an orderly manner. Clean up all the headers to be safe for
user mode and send notifications/patches to glibc, and the distributions must know that
they might be geting same files from two packages for a while.

Would we want a Kconfig option for a while, like SCSI_EXPORT_HEADERS so it can be turned
off?

Boaz
