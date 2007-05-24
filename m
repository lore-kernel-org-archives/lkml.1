Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbXEXWx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbXEXWx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbXEXWxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:53:52 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbXEXWxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:53:52 -0400
Date: Thu, 24 May 2007 15:53:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-Id: <20070524155304.ec944b50.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46540DB2.5000605@googlemail.com>
	<Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
	<4654AC94.6080601@googlemail.com>
	<20070523150122.f9946f37.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
	<20070523153730.e0e9e91d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
	<20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
	<20070524073131.GA17501@elte.hu>
	<Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>
	<20070524142908.f39f42ea.akpm@linux-foundation.org>
	<20070524145517.1f32cd94.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 15:35:45 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> > This is pretty-printing.  and creature-feep.
> > But lib/hexdump.c can probably do this if we add a "prefix/tag" string
> > parameter to it.
> > 
> > Hugh D. wants it to print 32-bit quantities, not just bytes.
> > Yet another parameter.
> > 
> > I'll look into these unless Christoph et al does so first.
> 
> I'd appreciate if you could do this. I just added a call to the function 
> in hexdump.c and got this ugly output. I think we need
> 
> 1. byte output

yup.  Obviously a suitable implementation would then permit 1-byte,2-byte,3-byte,etc
output.

> 2. A way to specify the width of the description.

Maybe not.  The caller could just ensure that the preamble strings are
all of the same length:

	hexdump("Bytes   ", ...);
	hexdump("Object  ", ...);
	hexdump("Redzone ", ...);

