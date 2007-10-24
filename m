Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbXJXCf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbXJXCf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbXJXCfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:35:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44091 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbXJXCfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:35:14 -0400
Date: Tue, 23 Oct 2007 20:35:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Eric St-Laurent <ericstl34@sympatico.ca>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-ID: <20071024023512.GW27248@parisc-linux.org>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx> <1193192346.8691.36.camel@perkele>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193192346.8691.36.camel@perkele>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 10:19:06PM -0400, Eric St-Laurent wrote:
> I don't know if copy-on-write semantics are really useful for current
> in-kernel uses, but I've coded and used a C++ string class like this in
> the past:

CoW isn't in the slightest bit helpful.  The point of these is to
provide an accumulator, therefore the majority of accesses to these
stringbufs are writes.

> Multiple string objects can share the same data, by increasing the nrefs
> count, a new data is allocated if the string is modified and nrefs > 1.

If we were trying to get rid of char * throughout the kernel, that might
make some sense; stringbufs have a more limited target though.

> Even without copy-on-write semantics and reference counting, I think
> this approach is better because it uses 1 less "object" and allocation:
> 
> struct string - "handle" (pointer really) to string data
> struct string_data - string data
> 
> versus:
> 
> struct stringbuf *sb - pointer to string object
> struct stringbuf - string object
> char *s (member of stringbuf) - string data

I think you missed the part of the patch where I said that the stringbuf
is normally allocated on the stack or as part of some other structure.
The only thing that should be allocated is the string itself.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
