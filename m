Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYEOBqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYEOBqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYEOBqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:46:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55423 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYEOBqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:46:07 -0400
Date: Thu, 15 May 2008 02:46:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mtd: mtdchar.c silence sparse warning
Message-ID: <20080515014600.GR13907@ZenIV.linux.org.uk>
References: <1210814530.6191.52.camel@brick> <20080514183837.460ba848.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514183837.460ba848.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 06:38:37PM -0700, Andrew Morton wrote:
> > -		if (copy_to_user(&((struct mtd_oob_buf *)argp)->length,
> > +		if (copy_to_user(argp + offsetof(struct mtd_oob_buf, length),
> >  				 &retlen, sizeof(buf.length)))
> >  			ret = -EFAULT;
> 
> Cleaner would be:
> 
> 	struct mtd_oob_buf __user *user_mtd_oob_buf = argp;
> 
> 	if (copy_to_user(&user_mtd_oob_buf->length, ...

Yup.  BTW, &((type __user *)p)->field) would work just fine too, but yeah,
local variable like that would be cleaner.
