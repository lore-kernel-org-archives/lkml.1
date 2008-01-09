Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYAIUY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYAIUY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYAIUYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:24:19 -0500
Received: from c60.cesmail.net ([216.154.195.49]:20803 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbYAIUYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:24:18 -0500
Subject: Re: Replacement for page fault notifiers?
From: Pavel Roskin <proski@gnu.org>
To: benh@kernel.crashing.org
Cc: Christoph Hellwig <hch@infradead.org>, Dave Airlie <airlied@gmail.com>,
       Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com
In-Reply-To: <1199908703.6734.133.camel@pasglop>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	 <20080108203235.GA772@infradead.org>
	 <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
	 <1199838407.6734.83.camel@pasglop> <1199902724.8050.11.camel@dv>
	 <20080109182157.GA32754@infradead.org>  <1199908703.6734.133.camel@pasglop>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 15:24:16 -0500
Message-Id: <1199910256.11485.14.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-10 at 06:58 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2008-01-09 at 18:21 +0000, Christoph Hellwig wrote:
> > On Wed, Jan 09, 2008 at 01:18:44PM -0500, Pavel Roskin wrote:
> > > notification without patching the kernel.  But if no such solution is
> > > found, I would also support reverting the patch that removed fault
> > > notifiers on i386.
> > 
> > With your fixation on not patching the kernel you sound like a windows
> > developer.

I just assumed (wrongly, as it seems) that the API change didn't remove
any useful functionality.

Also, I don't want to ask users with unusual hardware to patch their
kernels to take the trace.

> > There is no problem with patching the kernel, but the best
> > patching of that kernel is that which happens upstream so please folks
> > start submitting an mmiotrace variant for kernel inclusion.

The problem is that mmiotrace only makes sense in combination with
non-free drivers, and I'm not sure it would be welcome in the kernel
even if you say so.

The hooks for page faults could be useful for something (debugging, some
non-traditional swap implementations), but I don't want to invent
reasons why somebody else might need them.

> > Then again I don't quite get why you absolutely want to track pagefaults
> > anyway.  Just hooking into ioremap and read*/write* and iomap +
> > ioread*/iowrite* would be much easier and also a lot faster.  It would
> > also allow adding a nice sysfs attribute to enable this per-device.
> 
> Because binary drivers don't use ioread/iowrite/readX/writeX (or if they
> do, they've long been inlined in the blob). The only solution is to map
> things as non-accessible and trap the page faults.

Exactly.  In MadWifi, they are inlined on i386 and x86_64, and I cannot
ask every user with an unsupported card to get a Mac.

> It's a sane thing to do, Christoph, I don't think it's a unreasonable
> request to put the hooks back in.

Seconded.

-- 
Regards,
Pavel Roskin
