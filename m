Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbXJXVVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbXJXVVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbXJXVVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:21:13 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40283 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbXJXVVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:21:12 -0400
Date: Wed, 24 Oct 2007 15:21:10 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-ID: <20071024212110.GG27248@parisc-linux.org>
References: <20071024195847.GE27248@parisc-linux.org> <1193255992-14385-1-git-send-email-matthew@wil.cx> <0533759C-81D0-45CB-A663-088A6D4E56A9@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0533759C-81D0-45CB-A663-088A6D4E56A9@mac.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 04:59:48PM -0400, Kyle Moffett wrote:
> This seems unlikely to work reliably as the various "v*printf"  
> functions modify the va_list argument they are passed.  It may happen  
> to work on your particular architecture depending on how that  
> argument data is passed and stored, but you probably actually want to  
> make a copy of the varargs list for the first vsnprintf call.   

I based what I did on how printk works:

        va_start(args, fmt);
        r = vprintk(fmt, args);
        va_end(args);

It doesn't call va_* anywhere else.  I don't claim to be a varargs expert,
but if I'm wrong, I'm at least wrong the same way that printk is, so not
in any way that's significant for any other architecture Linux runs on.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
