Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbXDKO6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbXDKO6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbXDKO6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:58:21 -0400
Received: from lazybastard.de ([212.112.238.170]:54455 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbXDKO6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:58:20 -0400
Date: Wed, 11 Apr 2007 16:54:22 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nate Diller <nate.diller@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/13] fs: convert core functions to zero_user_page
Message-ID: <20070411145420.GB3531@lazybastard.org>
References: <20070411033600.11000.38285.patchbomb.py@localhost> <20070410225638.476cf89b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070410225638.476cf89b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 April 2007 22:56:38 -0700, Andrew Morton wrote:
> 
> And I'm surprised that this:
> 
> +static inline void memclear_highpage_flush(struct page *page, unsigned int offset, unsigned int size)
> +{
> +	return zero_user_page(page, offset, size);
> +}
> 
> compiled.  zero_user_page() returns void...

As does memclear_highpage_flush().  Some of my code looks like:
void some_func(...)
{
	if (foo)
		return do_foo(...);
	if (bar)
		return do_bar(...);
	...
}

do_foo() and do_bar() also return void.  Saves an extra line for the
return statment and the brackets.

Doesn't help in the code you quoted, of course.

Jörn

-- 
Measure. Don't tune for speed until you've measured, and even then
don't unless one part of the code overwhelms the rest.
-- Rob Pike
