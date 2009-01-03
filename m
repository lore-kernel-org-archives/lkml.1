Return-Path: <linux-kernel-owner+w=401wt.eu-S1760080AbZACSuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080AbZACSuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 13:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759118AbZACSuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 13:50:00 -0500
Received: from mail.fieldses.org ([141.211.133.115]:58358 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758704AbZACSt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 13:49:59 -0500
Date: Sat, 3 Jan 2009 13:49:21 -0500
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by
	sys_faccessat() [ver #2]
Message-ID: <20090103184921.GB20166@fieldses.org>
References: <20090102051905.GC1073@fieldses.org> <20090101235332.GA31840@fieldses.org> <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com> <29449.1230859152@redhat.com> <32481.1230897578@redhat.com> <20090102164505.GA10465@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102164505.GA10465@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 11:45:05AM -0500, bfields wrote:
> On Fri, Jan 02, 2009 at 11:59:38AM +0000, David Howells wrote:
> > J. Bruce Fields <bfields@fieldses.org> wrote:
> > 
> > > No.  I started bisecting, and it does appear to be a regression from the
> > > cred patches, but at some point in the middle there it hangs on boot (a
> > > softlockup report blames a spinlock in set_groups).
> > 
> > Do you remember which patch you were at?

More precisely:
	- The last working commit is b6dff3ec... "CRED: Separate task
	  security context from task_struct".
	- The first commit exhibiting the permissions problem is
	  a6f76f2... "CRED: Make execve() take advantage of
	  copy-on-write credentials".
	- The 9 commits in between (from f1752eec to d84f4f9) result in
	  a soft lookup on boot.

--b.
