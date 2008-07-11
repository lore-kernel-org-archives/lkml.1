Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbYGKUyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbYGKUyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbYGKUyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:54:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:35941 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbYGKUyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:54:09 -0400
Date: Fri, 11 Jul 2008 13:54:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch 13/17] Use WARN() in drivers/base/
Message-ID: <20080711135409.6638498d@infradead.org>
In-Reply-To: <20080711122011.7ddf42ef.akpm@linux-foundation.org>
References: <20080708093800.274504ba@infradead.org>
	<20080708095307.6423cb6f@infradead.org>
	<20080711122011.7ddf42ef.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 12:20:11 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 8 Jul 2008 09:53:07 -0700 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>Index:
> > linux.trees.git/drivers/base/core.c
> 
> A number of these patches had mangled signed-off-by: lines.
> 
> Please try to be consistent in the presence and placement of the ^---
> line at the end of the changelog.
> 
> I verified that all three copies of "Use WARN() in fs/" were the same.
> 
> I've decided that I don't like the whole thing :(  This:
> 
> #define WARN(condition, format...)
> ({					\ int __ret_warn_on
> = !!(condition);				\ if
> (unlikely(__ret_warn_on))					\
> __WARN_printf(format);					\
> unlikely(__ret_warn_on);					\ })
> 
> is not a WARN().  It is a WARN_ON() function.  The use of this name
> now leaves us no sensible name under which to implement
> 

I'm totally open to a better name.
Having a condition in there is really nice, it means we can fold the
if() into it in many cases. Just like BUG_ON() did.
