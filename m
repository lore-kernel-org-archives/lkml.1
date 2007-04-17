Return-Path: <linux-kernel-owner+w=401wt.eu-S1031162AbXDQQ25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031162AbXDQQ25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031161AbXDQQ25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:28:57 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52173 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031154AbXDQQ24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:28:56 -0400
Date: Tue, 17 Apr 2007 22:00:55 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Shaya Potter <spotter@cs.columbia.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  0/15] VFS based Union Mount
Message-ID: <20070417163055.GA11318@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070417131459.GA4001@in.ibm.com> <4624DB46.6040400@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4624DB46.6040400@cs.columbia.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 10:35:50AM -0400, Shaya Potter wrote:
> Bharata B Rao wrote:
> >Hi,
> >
> >Here is an attempt towards vfs based union mount implementation.
> >Union mount provides the filesytem namespace unification feature.
> >Unlike the traditional mounts which hide the contents of the mount point,
> >the union mount presents the merged view of the mount point and the
> >mounted filesytem.
> 
> does this approach allow one to add directories to the union and have it 
> behave normally.  namely when imagine one has the situation
> 
> dir-b
> dir-a/ (contains file foo)
> 
> 
> if one unions this and deletes foo, that will create a whiteout entry in 
> dir-a

(I guess you mean to say that this creates a whiteout in dir-b)

> 
> now, what happens if one does
> 
> dir-c
> dir-b (now contains whiteout, from previous union).
> dir-a (contains file foo)
> 
> will one see foo or not. i.e. are whiteouts only looked for in the 
> topmost dir, or in every dir?

No. foo is not visible. While looking for a file in a union mounted
directory, the lookup starts from the topmost directory and proceeds
downwards if the file isn't present the top layers. If a whiteout is
found in any of the top layers, the lookup is abondoned and -ENOENT
is removed. Thus until a whiteout exists in any upper layer for
a corresponding file in the lower layer, the lower layer file remains
hidden until the whiteout is removed.

However in the case of dir-c containing foo, the foo(from dir-c) will become
visible after union mounting dir-c on top of dir-b and dir-a.

Regards,
Bharata.
