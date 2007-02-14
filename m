Return-Path: <linux-kernel-owner+w=401wt.eu-S932534AbXBNUVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534AbXBNUVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbXBNUVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:21:05 -0500
Received: from kanga.kvack.org ([66.96.29.28]:51142 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932534AbXBNUVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:21:04 -0500
Date: Wed, 14 Feb 2007 18:17:36 -0200
From: Marcelo Tosatti <marcelo@kvack.org>
To: Dave Jones <davej@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>,
       Jordan Crouse <jordan.crouse@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use movntq version of fast_clear_page/fast_copy_page on Geode
Message-ID: <20070214201736.GA5794@dmt.lan>
References: <20070214190839.GA4864@dmt.lan> <20070214195546.GA2005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214195546.GA2005@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 02:55:46PM -0500, Dave Jones wrote:
> On Wed, Feb 14, 2007 at 05:08:39PM -0200, Marcelo Tosatti wrote:
>  > 
>  > movntq instruction is supported by Geode CPU's, so use
>  > fast_clear_page/fast_copy_page versions that have it.
> 
> it's supported, but is it a win ?
> The same was also true of the VIA C3/C7's, but due to
> poor memory bandwidth, it turned out to be slower in most cases.

Do you have the numbers for VIA C3/C7 around?

The Geode benefits from movntq instead of movq:

[marcelo@localhost ~]$ cat /proc/cpuinfo
processor       : 0
vendor_id       : Geode by NSC
cpu family      : 5
model           : 5
model name      : Geode(TM) Integrated Processor by National Semi
stepping        : 2
cpu MHz         : 364.898
cache size      : 32 KB
...

[marcelo@localhost ~]$ wget http://www.fenrus.demon.nl/athlon.c
...

[marcelo@localhost ~]$ ./athlon
Athlon test program $Id: fast.c,v 1.6 2000/09/23 09:05:45 arjan Exp $
clear_page() tests
clear_page function 'warm up run'        took 9565 cycles per page
clear_page function '2.4 non MMX'        took 3347 cycles per page
clear_page function '2.4 MMX fallback'   took 3389 cycles per page
clear_page function '2.4 MMX version'    took 2920 cycles per page
clear_page function 'faster_clear_page'  took 2912 cycles per page
clear_page function 'even_faster_clear'  took 2863 cycles per page

copy_page() tests
copy_page function 'warm up run'         took 9409 cycles per page
copy_page function '2.4 non MMX'         took 13161 cycles per page
copy_page function '2.4 MMX fallback'    took 13033 cycles per page
copy_page function '2.4 MMX version'     took 9288 cycles per page
copy_page function 'faster_copy'         took 9806 cycles per page
copy_page function 'even_faster'         took 8990 cycles per page

