Return-Path: <linux-kernel-owner+w=401wt.eu-S965676AbXHaPW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965676AbXHaPW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932283AbXHaPWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:22:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40206 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965328AbXHaPWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:22:47 -0400
Date: Fri, 31 Aug 2007 08:22:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Dmitry Monakhov <dmonakhov@sw.ru>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [11/36] Use page_cache_xxx in fs/buffer.c
In-Reply-To: <20070831081201.GO29452@kernel.dk>
Message-ID: <Pine.LNX.4.64.0708310821140.16456@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0708301113170.7975@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0708301843280.13292@schroedinger.engr.sgi.com>
 <20070831065613.GH29452@kernel.dk> <Pine.LNX.4.64.0708310003280.14375@schroedinger.engr.sgi.com>
 <20070831071142.GI29452@kernel.dk> <Pine.LNX.4.64.0708310012370.14375@schroedinger.engr.sgi.com>
 <20070831072611.GK29452@kernel.dk> <Pine.LNX.4.64.0708310028160.14632@schroedinger.engr.sgi.com>
 <20070831074338.GL29452@kernel.dk> <Pine.LNX.4.64.0708310049110.14743@schroedinger.engr.sgi.com>
 <20070831081201.GO29452@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007, Jens Axboe wrote:

> > Ok. So another solution maybe to limit the blocksizes that can be used 
> > with a device?
> 
> That'd work for creation, but not for moving things around.

What do you mean by moving things around? Creation binds a filesystem to a 
device.

> > Hmmmm.. We could keep the existing scheme too and check that device 
> > drivers split things up if they are too large? Isnt it possible today
> > to create a huge bio of 2M for huge pages and send it to a device?
> 
> Not sure, aren't the constituents of compound pages the basis for IO?

get_user_pages() serializes compound pages into the base pages. But doesnt 
the I/O layer coalesce these later into 2M chunks again?
