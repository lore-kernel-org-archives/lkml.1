Return-Path: <linux-kernel-owner+w=401wt.eu-S935764AbYD1PgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935764AbYD1PgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934077AbYD1Pf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:35:57 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55633 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbYD1Pf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:35:56 -0400
Date: Mon, 28 Apr 2008 11:29:40 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 6/19] UML - hppfs fixes
Message-ID: <20080428152940.GA7465@c2.user-mode-linux.org>
References: <20080425175608.GA11182@c2.user-mode-linux.org> <20080426.163132.194697674.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.163132.194697674.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 04:31:32PM +0800, WANG Cong wrote:
> > +		rem = copy_to_user(buf, &data->contents[off], count);
> > +		*ppos += count - rem;
> > +		if (rem > 0)
> > +			return -EFAULT;
> 
> Could you please explain why check 'rem' after using it here?

Actually, this isn't as wrong as it looks. copy_to_user returns what
hasn't been copied (rem == remaining).  So, I think the mistake is to
return -EFAULT here.  Returning the short count would be right, unless
rem == count, in which case we return -EFAULT.

       	      	 Jeff

-- 
Work email - jdike at linux dot intel dot com
