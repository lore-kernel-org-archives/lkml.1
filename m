Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbYAHEVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbYAHEVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 23:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYAHEVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 23:21:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40354 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYAHEVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 23:21:01 -0500
Date: Mon, 7 Jan 2008 20:20:50 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bunk@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Linux 2.6.24-rc7 Build-Failure at
 __you_cannot_kmalloc_that_much
Message-ID: <20080107202050.6926ae46@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0801071014450.22642@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
 <478200A4.4090707@linux.vnet.ibm.com>
 <20080107100733.3655f74f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0801071014450.22642@schroedinger.engr.sgi.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 10:31:53 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> We could replace the __you_cannot_kmalloc_that_much() with a BUG() 
> statement so we have the same effect in SLAB?
> 

sounds like a bad idea; a compile time failure is of course nicer than
a runtime failure for the cases we can find the bug at compile-time already.

We should however investigate using one of the two following gcc function attributes;
they can give the user a lot better diagnostic information than what we have
right now:


error ("message")
    If this attribute is used on a function declaration and a call to
such a function is not eliminated through dead code elimination or
other optimizations, an error which will include message will be
diagnosed. This is useful for compile time checking, especially
together with __builtin_constant_p and inline functions where checking
the inline function arguments is not possible through extern char
[(condition) ? 1 : -1]; tricks. While it is possible to leave the
function undefined and thus invoke a link failure, when using this
attribute the problem will be diagnosed earlier and with exact location
of the call even in presence of inline functions or when not emitting
debugging information.

warning ("message")
    If this attribute is used on a function declaration and a call to
such a function is not eliminated through dead code elimination or
other optimizations, a warning which will include message will be
diagnosed. This is useful for compile time checking, especially
together with __builtin_constant_p and inline functions. While it is
possible to define the function with a message in .gnu.warning*
section, when using this attribute the problem will be diagnosed
earlier and with exact location of the call even in presence of inline
functions or when not emitting debugging information. 

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
