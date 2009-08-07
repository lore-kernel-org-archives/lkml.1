Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbZHGBvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbZHGBvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 21:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZHGBvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 21:51:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbZHGBvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 21:51:35 -0400
Date: Thu, 6 Aug 2009 21:50:49 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Alasdair G Kergon <agk@redhat.com>
cc: Mark McLoughlin <markmc@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [dm-devel] [PATCH] block: silently error unsupported empty
 barriers too
In-Reply-To: <20090806114550.GL29899@agk-dp.fab.redhat.com>
Message-ID: <Pine.LNX.4.64.0908062148060.8764@hs20-bc2-1.build.redhat.com>
References: <1249557257.3721.55.camel@blaa> <20090806114550.GL29899@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Aug 2009, Alasdair G Kergon wrote:

> On Thu, Aug 06, 2009 at 12:14:17PM +0100, Mark McLoughlin wrote:
> > We should error all barriers, even empty barriers, on devices like
> > virtio_blk which don't support them.
>  
> Have you considered whether or not virtio_blk actually needs to
> support empty barriers?
> 
> Alasdair

This is only for request-based drivers, where it is the responsibility of 
blk-core to translate barriers. I think the empty barrier request anyway 
in blk_do_ordered, but with an error message. So the patch changes it to 
discard it early and queitly. It seems ok.

Mikulas
