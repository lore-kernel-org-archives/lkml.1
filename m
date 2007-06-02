Return-Path: <linux-kernel-owner+w=401wt.eu-S1761755AbXFBQ2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761755AbXFBQ2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 12:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760009AbXFBQ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 12:28:42 -0400
Received: from gw.goop.org ([64.81.55.164]:37035 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894AbXFBQ2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 12:28:42 -0400
Message-ID: <46619AB6.5060606@goop.org>
Date: Sat, 02 Jun 2007 09:28:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
CC: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [RFC 0/4] CONFIG_STABLE to switch off development checks
References: <20070531002047.702473071@sgi.com> <46603371.50808@goop.org>	 <Pine.LNX.4.64.0706011126030.2284@schroedinger.engr.sgi.com>	 <46606C71.9010008@goop.org> <1180797790.18535.6.camel@kleikamp.austin.ibm.com>
In-Reply-To: <1180797790.18535.6.camel@kleikamp.austin.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp wrote:
> I'm on Christoph's side here.  I don't think it makes sense for any code
> to ask to allocate zero bytes of memory and expect valid memory to be
> returned.
>   

Yes, everyone agrees on that.  If you do kmalloc(0), its never OK to
dereference the result.  The question is whether kmalloc(0) should complain.

> Would a compromise be to return a pointer to some known invalid region?
> This way the kmalloc(0) call would appear successful to the caller, but
> any access to the memory would result in an exception.
>   

Yes, that's what Christoph has posted.  I'm slightly concerned about
kmalloc() returning the same non-NULL address multiple times, but it
seems sound otherwise.

    J
