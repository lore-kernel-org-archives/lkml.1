Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbZGWFll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbZGWFll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 01:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbZGWFlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 01:41:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46406 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbZGWFlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 01:41:40 -0400
Subject: Re: [RFCv2][PATCH] flexible array implementation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Benjamin Blum <bblum@google.com>
Cc: vda.linux@googlemail.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       akpm@linux-foundation.org
In-Reply-To: <2f86c2480907221620u6da3a8e3h8273f6a9ee156f86@mail.gmail.com>
References: <20090721220017.60A219D3@kernel>
	 <2f86c2480907221357j5a09fd9au890f815db3750187@mail.gmail.com>
	 <1248299464.24021.334.camel@nimitz>
	 <2f86c2480907221620u6da3a8e3h8273f6a9ee156f86@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 22:41:37 -0700
Message-Id: <1248327697.24021.661.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 16:20 -0700, Benjamin Blum wrote:
> 
> >> How about a resize() function that can be
> >> used to either grow or shrink the array?
> >
> > I think growing is out of the question.  It has a fixed maximum size
> > already.  As for shrinking, there's probably a use case for when
> > something is large, then shrinks back down.  But, I think I'd want to
> > see a user for it, otherwise I'm just guessing at it too much.
> 
> Check out the reallocate logic in pidlist_uniq from my patch (the
> series you linked).

To me, it seems like you should just replace the cgroup_pidlist->list
with a 'struct flex_array *'.  It sounds like you're concerned that a
large cgroup_pidlist that was later shrunk would take up too much space.

That's a valid concern and it would be quite possible to make a
flex_array_clean() or truncate() or something similar.  Such a function,
given an index, could clean out the array at all points past the given
index.  Kinda the opposite of prealloc().

At the same time, you could get the same effect by allocating a new flex
array and doing copies like you are now with the normal arrays.  

-- Dave

