Return-Path: <linux-kernel-owner+w=401wt.eu-S934888AbXFFTBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934888AbXFFTBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762361AbXFFTBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:01:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:18006 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763978AbXFFTBX (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:01:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lIvegYKa9QokEWbz6V/XsKrm/rBa3nt8SGdO0wljZSUTaBzat98G0UfjtR3h3B1CZWxe12Q+lHvD3+wLCsf7CBg0dC9s/fIyimAVOUmZFNAxYDxLIc7TzDhDAxc5TRY0ul1u9PV+axzjmHatcY+qq05JkKmZ5/WM6eeFqKd0uMs=
Message-ID: <6934efce0706061201o13709f3fu4aa12e6a40fe7e06@mail.gmail.com>
Date: Wed, 6 Jun 2007 12:01:19 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: carsteno@de.ibm.com
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
In-Reply-To: <4666A319.1010901@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
	 <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au>
	 <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com>
	 <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
	 <4666A319.1010901@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07, Carsten Otte <cotte@de.ibm.com> wrote:
> Jared Hulbert wrote:
> > (2) failed with the following messages.  (This wasn't really busybox.
> > It was xxd, not statically link, hence the issue with ld.so)
> Could you try to figure what happend to subject page before? Was it
> subject to copy on write? With what flags has this vma been mmaped?
>
> thanks,
> Carsten

The vma->flags = 1875 = 0x753

This is:
VM_READ
VM_WRITE
VM_MAYREAD
VM_MAYEXEC
VM_GROWSDOWN
VM_GROWSUP
VM_PFNMAP

I assume no struct page exists for the pages of this file.  When
vm_no_page was called it seems it failed on a pte check since there is
no backing page structure.
