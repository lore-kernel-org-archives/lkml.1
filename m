Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbZLEO10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbZLEO10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 09:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbZLEO1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 09:27:24 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48993 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbZLEO1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 09:27:24 -0500
Date: Sat, 5 Dec 2009 07:27:29 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Emese Revfy <re.emese@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/31] Constify struct address_space_operations for
	2.6.32 v1
Message-ID: <20091205142729.GC9482@parisc-linux.org>
References: <4B198670.2000406@gmail.com> <4B198849.1060909@gmail.com> <20091205000845.GB9482@parisc-linux.org> <4B19AB28.6060805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B19AB28.6060805@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 05, 2009 at 01:36:56AM +0100, Emese Revfy wrote:
> Matthew Wilcox wrote:
> > On Fri, Dec 04, 2009 at 11:08:09PM +0100, Emese Revfy wrote:
> >> -	int (*writepage)(struct page *page, struct writeback_control *wbc);
> >> +	int (* const writepage)(struct page *page, struct writeback_control *wbc);
> > 
> > Umm.  What effect does this have?
> > What changes as a result of this patch?
> 
> My idea was that since all variables of this type are const, we might
> as well have the compiler enforce it for the future if you think that
> these fields should not be writable at all.

The compiler does already enforce it.  We do it like this:

struct address_space {
        const struct address_space_operations *a_ops;   /* methods */
}

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
