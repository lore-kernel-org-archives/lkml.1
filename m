Return-Path: <linux-kernel-owner+w=401wt.eu-S1763675AbYHFBzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763675AbYHFBzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 21:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbYHFBzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 21:55:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbYHFBzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 21:55:35 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
	interfaceforon access scanning
From: Eric Paris <eparis@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org
In-Reply-To: <20080805203052.3de22dd2@bree.surriel.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <20080804223249.GA10517@kroah.com>
	 <1217896374.27684.53.camel@localhost.localdomain>
	 <2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
	 <1217948212.27684.120.camel@localhost.localdomain>
	 <2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com>
	 <1217956796.11547.12.camel@paris.rdu.redhat.com>
	 <20080805103840.1aaa64a5@infradead.org>
	 <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	 <20080805112747.2c3c4650@infradead.org>
	 <1217961574.27684.129.camel@localhost.localdomain>
	 <20080805203052.3de22dd2@bree.surriel.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 21:55:19 -0400
Message-Id: <1217987719.27684.222.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 20:30 -0400, Rik van Riel wrote:
> On Tue, 05 Aug 2008 14:39:34 -0400
> Eric Paris <eparis@redhat.com> wrote:
> > On Tue, 2008-08-05 at 11:27 -0700, Arjan van de Ven wrote:
> 
> > > but close is... very limited in value. Open is a discrete event
> > > traditionally associated withh permission checks.
> > > Close... not so.  (And if you mmap memory, you can then close the file
> > > and still write to it via the mmap)
> > 
> > Thankfully my implementation will invalidate that close time check and
> > caching result.  It does the invalidating the same place we update mtime
> > and my understanding is that mmap has been updating mtime for quite a
> > while now. 
> 
> Then isn't the close time check superfluous, since you do the
> checks at change time already?

In the patches I posted, "checks" are done at open and close if the
result is not already in the cache.  Every write invalidates the cache
and thus the next open/close will do a "check."

So the longer a process keeps a file open the longer it is susceptible
to "unclean" data existing in that file.

