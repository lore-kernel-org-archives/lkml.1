Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYFCNev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYFCNev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 09:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYFCNem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 09:34:42 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:33457 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbYFCNel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:34:41 -0400
Subject: Re: [patch 6/8] Factor out sysctl pathname code
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
In-Reply-To: <20080531082757.GF24135@infradead.org>
References: <20080529113245.450308367@szeredi.hu>
	 <20080529113315.284080903@szeredi.hu>
	 <20080531082757.GF24135@infradead.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 03 Jun 2008 09:34:20 -0400
Message-Id: <1212500060.11369.3.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-05-31 at 04:27 -0400, Christoph Hellwig wrote:
> On Thu, May 29, 2008 at 01:32:51PM +0200, Miklos Szeredi wrote:
> > Convert the selinux sysctl pathname computation code into a standalone
> > function.
> 
> No point bloating core kernel for selinux mess.  And this whole routine
> should rather go away rather than moving it to core code.  While doing
> pathname based lookup for the label might work for the limited case
> of sysctl where there are no symlinks but is a rather dumb idea in
> general.  And reconstructing this path from the sysctl tables is twice
> as dumb.

I didn't see an alternative for fine-grained labeling of sysctl - the
pathname was the only stable key I could use as an index into policy;
xattrs or the like didn't make sense there.  And generating the pathname
from the sysctl tables ensured that we obtained a stable result that
wasn't mutable by userspace.  Do you have an alternative suggestion?

-- 
Stephen Smalley
National Security Agency

