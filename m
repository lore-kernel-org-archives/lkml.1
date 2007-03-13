Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbXCMFGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbXCMFGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 01:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbXCMFGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 01:06:04 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60790 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbXCMFGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 01:06:02 -0400
Date: Mon, 12 Mar 2007 22:04:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: hansendc@us.ibm.com, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, menage@google.com, xemul@sw.ru
Subject: Re: [RFC][PATCH 2/7] RSS controller core
Message-Id: <20070312220439.677b4787.akpm@linux-foundation.org>
In-Reply-To: <20070312224129.GC21258@MAIL.13thfloor.at>
References: <45ED7DEC.7010403@sw.ru>
	<45ED80E1.7030406@sw.ru>
	<20070306140036.4e85bd2f.akpm@linux-foundation.org>
	<45F3F581.9030503@sw.ru>
	<20070311045111.62d3e9f9.akpm@linux-foundation.org>
	<20070312010039.GC21861@MAIL.13thfloor.at>
	<1173724979.11945.103.camel@localhost.localdomain>
	<20070312224129.GC21258@MAIL.13thfloor.at>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 12 Mar 2007 23:41:29 +0100 Herbert Poetzl <herbert@13thfloor.at> wrote:
> On Mon, Mar 12, 2007 at 11:42:59AM -0700, Dave Hansen wrote:
> > How about we drill down on these a bit more.
> > 
> > On Mon, 2007-03-12 at 02:00 +0100, Herbert Poetzl wrote:
> > >  - shared mappings of 'shared' files (binaries 
> > >    and libraries) to allow for reduced memory
> > >    footprint when N identical guests are running
> > 
> > So, it sounds like this can be phrased as a requirement like:
> > 
> > 	"Guests must be able to share pages."
> > 
> > Can you give us an idea why this is so? 
> 
> sure, one reason for this is that guests tend to
> be similar (or almost identical) which results
> in quite a lot of 'shared' libraries and executables
> which would otherwise get cached for each guest and
> would also be mapped for each guest separately

nooooooo.  What you're saying there amounts to text replication.  There is
no proposal here to create duplicated copies of pagecache pages: the VM
just doesn't support that (Nick has soe protopatches which do this as a
possible NUMA optimisation).

So these mmapped pages will contiue to be shared across all guests.  The
problem boils down to "which guest(s) get charged for each shared page".

A simple and obvious and easy-to-implement answer is "the guest which paged
it in".  I think we should firstly explain why that is insufficient.

