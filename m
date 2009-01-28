Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbZA1Rgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbZA1Rgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZA1Rgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:36:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50401 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZA1Rgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:36:32 -0500
Date: Wed, 28 Jan 2009 12:36:18 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, hch@infradead.org, corbet@lwn.net,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090128173618.GA3174@infradead.org>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org> <20090122203248.GA20159@infradead.org> <20090123045646.GK15750@one.firstfloor.org> <20090127165504.53ed7a2d.akpm@linux-foundation.org> <20090128031439.GA11025@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128031439.GA11025@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 04:14:39AM +0100, Oleg Nesterov wrote:
> I didn't send the actual patch. The idea is,
> 
> 	can't we use O_LOCK_FLAGS bit? I agree, it is a bit ugly,
> 	and I won't insist if you don't like is.
> 
> 		static inline int try_lock_f_flags(struct file *file)
> 		{
> 			return !test_and_set_bit(O_LOCK_FLAGS, file->f_flags);
> 		}

->f_flags is an unsigned int and the bit macros need an unsigned long.
Increasing the size of struct file for this is probably a bad idea.

