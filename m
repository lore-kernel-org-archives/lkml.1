Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbYHINji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbYHINji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 09:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYHINj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 09:39:29 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60787 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYHINj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 09:39:28 -0400
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>
In-Reply-To: <200808090837.07417.arnd@arndb.de>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808090039.20289.arnd@arndb.de> <1218242614.19082.65.camel@nimitz>
	 <200808090837.07417.arnd@arndb.de>
Content-Type: text/plain
Date: Sat, 09 Aug 2008 06:39:25 -0700
Message-Id: <1218289165.19082.74.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-09 at 08:37 +0200, Arnd Bergmann wrote:
> On Saturday 09 August 2008, Dave Hansen wrote:
> > On Sat, 2008-08-09 at 00:39 +0200, Arnd Bergmann wrote:
> > > The main problem I see with that would be atomicity: If you want multiple
> > > processes to keep interacting with each other, you need to save them at
> > > the same point in time, which gets harder as you split your interface into
> > > more than a single file descriptor.
> > 
> > It could take ages to write out a checkpoint even to a single fd, so I
> > suspect we'd have the exact same kinds of issues either way.
> 
> I guess either way, you have to SIGSTOP (or similar) all the tasks you want
> to checkpoint atomically before you start saving the contents.
> If you use a single fd, you can do that under the covers, when using a 
> more complex file system, it seems more logical to require an explicit
> interface for this.

Oh, we're already working on patches to the freezer code to do this for
us.  There's a branch in here from Matt H. that's doing just that:

http://git.kernel.org/?p=linux/kernel/git/daveh/linux-2.6-next-lxc.git;a=shortlog

-- Dave

