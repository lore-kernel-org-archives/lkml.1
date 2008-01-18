Return-Path: <linux-kernel-owner+w=401wt.eu-S1763598AbYARSUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763598AbYARSUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbYARSUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:20:46 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:1679 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642AbYARSUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:20:45 -0500
Date: Fri, 18 Jan 2008 19:20:43 +0100
From: Olivier Galibert <galibert@pobox.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Why is the kfree() argument const?
Message-ID: <20080118182042.GA79879@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	linux-kernel@vger.kernel.org
References: <2895123.436161200674749664.JavaMail.www@wwinf4611>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2895123.436161200674749664.JavaMail.www@wwinf4611>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 05:45:49PM +0100, ecolbus@voila.fr wrote:
> The malloc attribute is exactly about this : giving the compiler the
> indication that no other pointer aliases this object, allowing for
> better optimizations.

If you put a malloc attribute on the allocator and no free attribute
on the deallocator, you can get bugs indeed.  GIGO.


> Yes. Bad things start to happen when users add wrong indications to
> the compiler. By adding the "const" indication to kfree(), the programmer
> wrongly tells that it can optimize reading the values pointed to before or
> after calling the function (if it is also sure that they cannot be
> read/written otherwise). Current gcc implementations seem quite
> conservative in this regard, and don't optimize that much, but what about
> the future?

The future should be quite nice because:

- the compiler can not know that kmalloc does not have an alias to
  the pointer tucked somewhere accessible by other non-inline functions
  (as kfree is), especially since it does have aliases in practice, so
  it cannot prove to "not read/written otherwise" part without the
  malloc attribute

- if you add the (non-standard C) malloc attribute to kmalloc, then
  you also add the free attribute to kfree which tells the compiler
  that the pointer is invalid after the call, which ensures no
  accesses will be moved after it

  OG.
