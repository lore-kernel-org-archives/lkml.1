Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbXD0L6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbXD0L6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 07:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbXD0L6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 07:58:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42490 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755672AbXD0L6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 07:58:45 -0400
Date: Fri, 27 Apr 2007 04:58:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mackerras <paulus@samba.org>
cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <17969.55533.59287.509889@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0704270452370.21003@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org>
 <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org>
 <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
 <20070426235542.bad7035a.akpm@linux-foundation.org>
 <17969.55533.59287.509889@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Paul Mackerras wrote:

> Option (b) would be a bit of an ugly hack.
> 
> Which leaves option (c) - unless you have a further option.  So I have
> to say I support Christoph on this, at least as far as the general
> principle is concerned.

We could approximate option (b) by setting a standard page size for the 
page cache and set the same page size in SLUB (slub is already boot time 
configurable in that respect). That will make large portions of the VM 
use the same page order. I can try to add similar controls to the page 
cache.

If the page size is set too high for a mount then we use the buffer 
head functionality to split the higher order page into pieces of the 
appropriate size. That could limit the number of page sizes that we need 
to support.

But I think we should first see how well Mel's antifrag work does.


