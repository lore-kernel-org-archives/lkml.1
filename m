Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZBDIiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZBDIiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbZBDIiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:38:46 -0500
Received: from ozlabs.org ([203.10.76.45]:56688 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZBDIip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:38:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Arnold <jbarnold@mit.edu>
Subject: Re: [PATCH 2/7] x86: Add an option to compile with -ffunction-sections -fdata-sections
Date: Wed, 4 Feb 2009 19:08:41 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Denys Vlasenko <vda.linux@googlemail.com>, Tim Abbott <tabbott@mit.edu>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Nikanth Karthikesan <knikanth@suse.de>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-2-git-send-email-jbarnold@mit.edu> <1228521840-3886-3-git-send-email-jbarnold@mit.edu>
In-Reply-To: <1228521840-3886-3-git-send-email-jbarnold@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041908.42173.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2008 10:33:55 Jeff Arnold wrote:
> From: Waseem Daher <wdaher@mit.edu>
> 
> This patch makes it possible to link and boot an x86 kernel with
> -ffunction-sections and -fdata-sections enabled.

Nice:
   text	   data	    bss	    dec	    hex	filename
3575210	 361820	 319488	4256518	 40f306	vmlinux-with-sections
3579626	 364892	 323584	4268102	 412046	vmlinux-no-sections

> +config FUNCTION_DATA_SECTIONS
> +	bool "Compile with -ffunction-sections -fdata-sections"
> +	depends on !FTRACE
> +	help
> +	  If you say Y here the compiler will give each function
> +	  and data structure its own ELF section.

You need to make this depend on X86, otherwise allmodconfig will turn it on
and break other archs.

What's the conflict with FTRACE?

Thanks,
Rusty.
