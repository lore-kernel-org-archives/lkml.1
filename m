Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYFJO5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYFJO5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYFJO5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:57:13 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43869 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752682AbYFJO5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:57:12 -0400
Date: Tue, 10 Jun 2008 09:57:11 -0500
From: Jack Steiner <steiner@sgi.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: Re: [patch 03/11] GRU Driver - driver internal header files
Message-ID: <20080610145711.GB29042@sgi.com>
References: <20080609211028.110089743@attica.americas.sgi.com> <20080609211045.488884093@attica.americas.sgi.com> <adak5gy70hh.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adak5gy70hh.fsf@cisco.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 02:38:18PM -0700, Roland Dreier wrote:
>  > +/*
>  > + * Structure used to pass TLB flush parameters to the driver
>  > + */
>  > +struct gru_flush_tlb_req {
>  > +	unsigned long	gseg;
>  > +	unsigned long	vaddr;
>  > +	size_t		len;
>  > +};
> 
> This and other data structures you pass into the kernel via ioctl() are
> not 32/64 clean.  So a 32-bit process (which can easily run on a 64-bit
> x86-64 kernel) will end up sending garbage to the kernel.

Good point in general but I don't this this will be an issue for us.
The data structures are used only in libgru.so - a library used to
externalize the GRU to user applications.  We will provide only -64
bit versions of this library.

If an abusive -32 bit application _tried_ to issue the system calls, the
parameters should fail the validity checking in the driver.


--- jack
