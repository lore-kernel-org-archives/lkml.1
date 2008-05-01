Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbYEAV0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbYEAV0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761249AbYEAV0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:26:04 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:45164 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbYEAV0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:26:03 -0400
Subject: Re: [PATCH] fix flags length in net 9p
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       lucho@ionkov.net, ericvh@gmail.com
In-Reply-To: <20080501141919.78b7dc4f.akpm@linux-foundation.org>
References: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com>
	 <20080501141919.78b7dc4f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 14:26:00 -0700
Message-Id: <1209677160.12461.267.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-01 at 14:19 -0700, Andrew Morton wrote:
> On Thu, 1 May 2008 17:08:05 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Some files in the net/9p directory uses "int" for flags. This can
> > cause hard to find bugs on some architectures. This patch converts the
> > flags to use "long" instead.
> 
> gargh.
> 
> > This bug was discovered by doing an allyesconfig make on the -rt kernel
> > where checks are done to ensure all flags are of size sizeof(long).
> 
> I was about to suggest that we do something like that...
> 
> I wonder how messy it is.  I long ago lost the ability to follow the
> convolutions in include/linux/spinlock*.h :(  gotta patch?

The check that's in -rt for this uses BUILD_BUG_ON(), and it's extremely
cryptic when there is a failure .. Most people will be baffled why the
build stopped. If a check went into mainline it should at least give you
some sort of idea what's happening ..

Daniel

