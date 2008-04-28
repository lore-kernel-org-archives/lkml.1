Return-Path: <linux-kernel-owner+w=401wt.eu-S965961AbYD1PuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965961AbYD1PuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936383AbYD1PqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:46:13 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55745 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936377AbYD1PqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:46:12 -0400
Date: Mon, 28 Apr 2008 11:45:24 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/19] UML - Tidy stub management code
Message-ID: <20080428154524.GE7334@c2.user-mode-linux.org>
References: <20080425175606.GA11174@c2.user-mode-linux.org> <20080426.180112.184545994.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.180112.184545994.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 06:01:12PM +0800, WANG Cong wrote:
> > +	/*
> > +	 * When the stub stops, we find the following values on the
> > +	 * beginning of the stack:
> > +	 * (long) return_value
> > +	 * (long) offset to failed sycall data (0 if no error)
> > +	 */
> > +	ret = *((unsigned long *) stack);
> 
> 
> I am afraid the value will be truncated on 64bit machine, since
> 'ret' is 'int' while 'stack' points to an 'unsigned long'.
> 
> Is this expected?

That's dubious, but I don't think it breaks anything.  On LE, *(int *)
and *(long *) will give you the same answer, and the value here is an
error code, which fits into 32 bits.

      	    	       Jeff

-- 
Work email - jdike at linux dot intel dot com
