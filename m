Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYAIT7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYAIT7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYAIT7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:59:11 -0500
Received: from gate.crashing.org ([63.228.1.57]:46750 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbYAIT7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:59:11 -0500
Subject: Re: Replacement for page fault notifiers?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Roskin <proski@gnu.org>, Dave Airlie <airlied@gmail.com>,
       Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com
In-Reply-To: <20080109182157.GA32754@infradead.org>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	 <20080108203235.GA772@infradead.org>
	 <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
	 <1199838407.6734.83.camel@pasglop> <1199902724.8050.11.camel@dv>
	 <20080109182157.GA32754@infradead.org>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 06:58:23 +1100
Message-Id: <1199908703.6734.133.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 18:21 +0000, Christoph Hellwig wrote:
> On Wed, Jan 09, 2008 at 01:18:44PM -0500, Pavel Roskin wrote:
> > notification without patching the kernel.  But if no such solution is
> > found, I would also support reverting the patch that removed fault
> > notifiers on i386.
> 
> With your fixation on not patching the kernel you sound like a windows
> developer.  There is no problem with patching the kernel, but the best
> patching of that kernel is that which happens upstream so please folks
> start submitting an mmiotrace variant for kernel inclusion.
> 
> Then again I don't quite get why you absolutely want to track pagefaults
> anyway.  Just hooking into ioremap and read*/write* and iomap +
> ioread*/iowrite* would be much easier and also a lot faster.  It would
> also allow adding a nice sysfs attribute to enable this per-device.

Because binary drivers don't use ioread/iowrite/readX/writeX (or if they
do, they've long been inlined in the blob). The only solution is to map
things as non-accessible and trap the page faults.

It's a sane thing to do, Christoph, I don't think it's a unreasonable
request to put the hooks back in.

Cheers,
Ben.


