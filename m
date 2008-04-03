Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbYDCXjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbYDCXjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbYDCXj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:39:29 -0400
Received: from ozlabs.org ([203.10.76.45]:40176 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYDCXj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:39:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] docbook: some kernel-locking fixes
Date: Fri, 4 Apr 2008 09:39:01 +1000
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       mattilinnanvuori@yahoo.com
References: <20080402144750.4837bf17.rdunlap@xenotime.net>
In-Reply-To: <20080402144750.4837bf17.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804040939.01951.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2008 07:47:50 Randy Dunlap wrote:
> From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
> +<chapter id="try-variants">
> + <title>The try variants</title>
> +
> +  <para>
> +    <function>spin_trylock()</function> does not spin but returns non-zero
> +    if it acquires the spinlock on the first try or 0 if not.
> +  </para>
> +
> +  <para>
> +    <function>mutex_trylock()</function> does not suspend your task
> +    but returns non-zero if it could lock the mutex on the first try
> +    or 0 if not.
> +  </para>
> +
> +  <para>
> +    <function>down_trylock()</function> does not suspend your task
> +    but returns 0 if it could get the semaphore on the first try or
> +    non-zero if not. The return value is the inverse of that of
> +    <function>spin_trylock()</function> and <function>mutex_trylock()
> +    </function>.
> +  </para>
> +</chapter>

OK, other than documenting the inconsistent horror of down_trylock, I don't 
like this patch.  This document is not about documenting the functions, but 
providing an overview and pointing to them (where you can read to your 
heart's content).

This is a worthy addition, but it's a paragraph, not a chapter.  Unless you 
want to document why you would use the trylock variants (can mutex_trylock 
and down_trylock be used from interrupt context?  Or are they only useful to 
avoid deadlock?  How are they actually used in the kernel?)

Thanks,
Rusty.
