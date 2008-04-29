Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYD2Vdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYD2Vdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYD2Vdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:33:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236AbYD2Vdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:33:32 -0400
Date: Tue, 29 Apr 2008 14:33:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       torvalds@linux-foundation.org, tony.luck@intel.com, clameter@sgi.com
Subject: Re: [PATCH 1/2] mm: Avoid putting a bad page back on the LRU
Message-Id: <20080429143329.3a17ef91.akpm@linux-foundation.org>
In-Reply-To: <20080428192358.GB14629@sgi.com>
References: <20080428192358.GB14629@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 14:23:58 -0500
Russ Anderson <rja@sgi.com> wrote:

> --- test.orig/include/linux/kernel.h	2008-04-25 15:22:07.640501421 -0500
> +++ test/include/linux/kernel.h	2008-04-25 15:42:02.826266036 -0500
> @@ -412,6 +412,7 @@ struct sysinfo {
>  	unsigned long totalhigh;	/* Total high memory size */
>  	unsigned long freehigh;		/* Available high memory size */
>  	unsigned int mem_unit;		/* Memory unit size in bytes */
> +	unsigned int badpages;		/* Number of bad (PG_memerror) pages */
>  	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
>  };

eek.  sys_sysinfo() copies this structure out to userspace verbatim. 
Increasing its size by four bytes will cause memory scribbles in userspace
applications.

That's fixable by suitably adjusting sysinfo._f, but given the lack of
version information in the sysinfo struct, I'm not sure how useful this
change really is.

