Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbYCZNKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbYCZNKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 09:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759787AbYCZNKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 09:10:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42639 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759747AbYCZNKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 09:10:24 -0400
Subject: Re: why so many unexported headers checking __KERNEL__?
From: David Woodhouse <dwmw2@infradead.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0803260846390.6148@localhost.localdomain>
References: <alpine.LFD.1.00.0803230229530.1203@localhost.localdomain>
	 <1206533324.9540.268.camel@pmac.infradead.org>
	 <alpine.LFD.1.00.0803260846390.6148@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 13:10:22 +0000
Message-Id: <1206537022.9540.274.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-26 at 08:53 -0400, Robert P. J. Day wrote:
> not surprisingly, the only reason i noticed the above was because i
> hacked together a short script that went looking for all of the above
> and i was surprised at the number of files it identified. 

It's not _that_ surprising. Remember, before headers_install people just
used to copy _all_ the headers across, and so the only way to hide stuff
was to wrap entire files in #ifdef __KERNEL__.

> p.s. the other case that could be identified is when a header file has
> its *entire* contents encased in a __KERNEL__ test, (either ifdef or
> ifndef).  AFAICT, unless that kind of test is partitioning *some* of a
> header file content from the remainder, there's little value in a
> __KERNEL__test if the end result is to either:
> 
>   a) leave the file exactly as is, or
>   b) reduce it to empty

Right.

If it's entirely #ifndef __KERNEL__ then it's a userspace header. It
probably doesn't live in the kernel source tree at all.

If it's entirely #ifdef __KERNEL__ then it shouldn't be exported at all
(although when we do that we sometimes have to deal with userspace
programs which include it even though it's empty).

-- 
dwmw2

