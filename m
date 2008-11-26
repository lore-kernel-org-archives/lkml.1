Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYKZMKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYKZMKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYKZMKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:10:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44135 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbYKZMKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:10:42 -0500
Date: Wed, 26 Nov 2008 13:21:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 23/24] perfmon: kernel documentation
Message-ID: <20081126122107.GV6703@one.firstfloor.org>
References: <492d0c14.02225e0a.15ab.6f8e@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492d0c14.02225e0a.15ab.6f8e@mx.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 12:43:00AM -0800, eranian@googlemail.com wrote:

I assume you'll be also submitting manpages with the same information?

> +
> +   A monitoring session is uniquely identified by a file descriptor obtained
> +   when the session is created. File sharing semantics apply to access the
> +   session inside a process. A session is never inherited across fork. The file
> +   descriptor can be used to receive counter overflow notifications or when the
> +   sampling buffer is full. It is possible to use poll/select on the descriptor
> +   to wait for notifications from multiple sessions. Similarly, the descriptor
> +   supports asynchronous notifications via SIGIO.

What happens when the fd is passed between processes using unix sockets fd 
passing?

> +
> +    We have released a simple monitoring tool to demonstrate the features of
> +    the interface. The tool is called pfmon and it comes with a simple helper
> +    library called libpfm. The library comes with a set of examples to show

I don't think "simple" is the right word to describe pfmon/libpfm @)

> +    There maybe other tools available for perfmon.

s/maybe/are/ ?

> +
> +   To destroy a session, the regular close() system call is used.

...

Some simple syscall examples would be nice. e.g. how to set up a counter
that it can be accessed using RDPMC on x86.

> +	/sys/kernel/perfmon/arg_mem_max(read-write):
> +
> +		Maximum size of vector arguments expressed in bytes.
> +		It can be modified but must be at least a page.
> +		Default: PAGE_SIZE

Is there any good reason ever to enlarge this beyond a page?

If it just depends on future hardware it would make more sense
to let a driver patch for that adjust it.

-Andi
-- 
ak@linux.intel.com
