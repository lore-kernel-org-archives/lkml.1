Return-Path: <linux-kernel-owner+w=401wt.eu-S1762920AbYFES55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762920AbYFES55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761427AbYFES5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:57:47 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36335 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYFES5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:57:46 -0400
Date: Thu, 5 Jun 2008 12:57:45 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: ip_fast_csum() requires a memory clobber on its inline asm
Message-ID: <20080605185744.GA30405@parisc-linux.org>
References: <20080605160735.2801.34832.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605160735.2801.34832.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 05:07:35PM +0100, David Howells wrote:
>  	    : "=r" (sum), "=r" (iph), "=r" (ihl), "=r" (inc), "=&r"(tmp)
>  	    : "0" (sum), "1" (iph), "2" (ihl), "3" (4),
>  	    "m"(*(volatile struct { int _[100]; } *)iph)

Do you still need the input "m" constraint?

> -	    : "icc0", "icc1"
> +	    : "icc0", "icc1", "memory"
>  	    );
>  
>  	return (__force __sum16)~sum;

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
