Return-Path: <linux-kernel-owner+w=401wt.eu-S1760434AbYCGNvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760434AbYCGNvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 08:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbYCGNvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 08:51:38 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:38441 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbYCGNvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 08:51:37 -0500
Date: Fri, 7 Mar 2008 06:51:20 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Luck, Tony" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ia64: fix getpid and set_tid_address fast system calls for pid namespaces
Message-ID: <20080307135120.GA29388@parisc-linux.org>
References: <47D141C1.2030604@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D141C1.2030604@openvz.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 04:23:13PM +0300, Pavel Emelyanov wrote:
> @@ -34,6 +35,9 @@
>  	DEFINE(SIGFRAME_SIZE, sizeof (struct sigframe));
>  	DEFINE(UNW_FRAME_INFO_SIZE, sizeof (struct unw_frame_info));
>  
> +	BUILD_BUG_ON(sizeof(struct upid) != 32);
> +	DEFINE(IA64_UPID_SHIFT, 5);
> +
>  	BLANK();
>  
>  	DEFINE(TI_FLAGS, offsetof(struct thread_info, flags));

This might work better with ilog2().  Something like this perhaps?

	BUILD_BUG_ON(!is_power_of_2(sizeof(struct upid)))
	DEFINE(IA64_UPID_SHIFT, ilog2(sizeof(struct upid)))

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
