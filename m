Return-Path: <linux-kernel-owner+w=401wt.eu-S965388AbXCGNbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965388AbXCGNbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965425AbXCGNbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:31:13 -0500
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:47488 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965388AbXCGNbM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:31:12 -0500
X-BigFish: VP
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: return negative number for unsigned long function in kernel
Date: Wed, 7 Mar 2007 08:31:09 -0500
Message-ID: <314BE1148B8C8D468A05944FDF577583069B0222@MRE02.enterprise.com>
In-Reply-To: <45EE09B4.40207@zytor.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: return negative number for unsigned long function in kernel
Thread-Index: AcdgUQ9Q8zdevGz+Ts6fonB3n/reWwAaRMUg
References: <314BE1148B8C8D468A05944FDF577583069B021E@MRE02.enterprise.com> <45EE09B4.40207@zytor.com>
From: "Chen, Dongliang" <Chen.D@ems-t.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Andreas Schwab" <schwab@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter & Andreas,

Thank you very much for your help. 

I understood that the kernel error numbers are limited. The largest
error number for i386 (kernel 2.6) is 131 so far.  Assume that the
virtual address returned from do_mmap_pgoff will never exceed (unsigned
long)(-1000L), which is in the address range one page below the maximum
virtual address, then IS_ERR_VALUE() should work.

Dongliang Chen

Staff Engineer
EMS Technologies, Inc - Defense & Space Systems
660 Engineering Dr 
Norcross, GA 30092
Tel: 770-263-9200 x 4379


-----Original Message-----
From: H. Peter Anvin [mailto:hpa@zytor.com] 
Sent: Tuesday, March 06, 2007 7:39 PM
To: Chen, Dongliang
Cc: linux-kernel@vger.kernel.org
Subject: Re: return negative number for unsigned long function in kernel


H. Peter Anvin wrote:
>If you want to test for errorness, you could use the macro 
>IS_ERR_VALUE().  Unfortunately the macro isn't all that safe, in that
it 
>will give you the wrong answer if it's ever used on something that 
>*isn't* an unsigned long.

-----Original Message-----
From: Andreas Schwab [mailto:schwab@suse.de] 
Sent: Tuesday, March 06, 2007 2:06 PM
To: Chen, Dongliang
Cc: linux-kernel@vger.kernel.org
Subject: Re: return negative number for unsigned long function in kernel

Andreas Schwab wrote:
>The return value is directly passed to user space (it's the guts of the
>mmap syscall).  The glibc wrapper transforms it appropriately so that
errno >is set and -1 is returned if there is an error.

