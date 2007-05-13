Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbXEMGlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbXEMGlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbXEMGlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:41:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:45018 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbXEMGlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GCIe0c9hMGJqBDmlux+pmmxjp7BV12HxM3Z4LHglO4VmC9po/j75UM1tCgZ2wFCeXVosjDN7CI+H9c8fnIDOkCeQ9XxG8upZNaCjz6/4CEocFTN1dboEqHXX0llFmew1YXsObAcAz7nOV0XAzH6acv5o+qBu+2h20A5fw8/GmXs=
Message-ID: <86802c440705122341q3f565d10qec5fb60373cc6824@mail.gmail.com>
Date: Sat, 12 May 2007 23:41:06 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH]x86_64: build and use GDT on copied compressed kernel
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200705130752.56041.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
	 <200705130752.56041.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/07, Andi Kleen <ak@suse.de> wrote:
> On Sunday 13 May 2007 07:33:14 Yinghai Lu wrote:
>
> Can you please give a little more description on why you think the patch
> is needed? Also we need a Signed-off-by line.

in the arch/x86_64/boot/compressed/head.S.
it switch to 64 bit mode and then copy compressed image to higher
address. and jump the copied image, then decompressed the compressed
image to final uncompressed kernel and it may overlapped with original
loaded compressed kernel image.

before jump to 64 bit mode, it will create new page table in some
place higher in copied compressed kernel image. but still use the GDT
in place of original loaded compressed image.  So the GDT will be
overwriten in the middle of decompressing.

So we could change to build the GDT like page table together with
copied compressed kernel.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

http://lkml.org/lkml/2007/5/13/8
