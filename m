Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbYGDDe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbYGDDe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 23:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271AbYGDDeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 23:34:17 -0400
Received: from rrcs-96-10-117-168.se.biz.rr.com ([96.10.117.168]:45652 "EHLO
	lap75545.ornl.gov" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755568AbYGDDeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 23:34:16 -0400
X-Greylist: delayed 1003 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 23:34:15 EDT
Subject: Re: Higher than expected disk write(2) latency
From: David Dillow <dave@thedillows.org>
To: Martin Sustrik <sustrik@fastmq.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Roger Heflin <rogerheflin@gmail.com>,
       Martin Lucina <mato@kotelna.sk>, linux-kernel@vger.kernel.org
In-Reply-To: <486BC6F7.2090709@fastmq.com>
References: <20080628121131.GA14181@nodbug.moloch.sk>
	 <48663873.5010200@gmail.com> <486921AD.8060308@fastmq.com>
	 <48692DC0.6060904@gmail.com> <486BB14D.5060609@fastmq.com>
	 <x49abh0p2y1.fsf@segfault.boston.devel.redhat.com>
	 <486BC6F7.2090709@fastmq.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jul 2008 23:16:24 -0400
Message-Id: <1215141384.2284.4.camel@lap75545.ornl.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-07-02 at 20:20 +0200, Martin Sustrik wrote:
> We are using librt, queueing 10240 writes, 512 bytes each.
> 
> We'll retry with libaio. Thanks for advice.

I've gotten good results going direct to the Linux AIO calls, but before
you go too far from your existing code base, are you using a single file
descriptor with the librt aio_*() routines? If so, that may be part of
your problem, as the library will serialize requests to the same fd. I
just pre-dup()'d the descriptor for each of the (max 32) requests I'd
have in flight for a toy stress-tester I wrote. With 10240 requests,
that may be a bit excessive, but it'd point out if that was part of the
problem fairly quickly.
