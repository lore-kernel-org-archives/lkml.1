Return-Path: <linux-kernel-owner+w=401wt.eu-S1762199AbYHFPr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762199AbYHFPr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760889AbYHFPqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:46:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760835AbYHFPqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:46:11 -0400
Date: Wed, 6 Aug 2008 11:46:04 -0400
From: Rik van Riel <riel@redhat.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: "Theodore Tso" <tytso@MIT.EDU>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
Message-ID: <20080806114604.5a714d11@cuia.bos.redhat.com>
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4AF8@USILMS12.ca.com>
References: <20080805205129.37d873f0@bree.surriel.com>
	<2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com>
	<20080806150857.GD14109@mit.edu>
	<2629CC4E1D22A64593B02C43E855530304AE4AF8@USILMS12.ca.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 11:33:23 -0400
"Press, Jonathan" <Jonathan.Press@ca.com> wrote:

> Even so, I don't think your extreme examples are really parallel to what
> we do.  Personally, I think that scanning on open, exec and close is not
> excessive.  
> 
> And in fact, we do go out of our way to avoid scanning when it really
> isn't necessary.  For example, that's the reason that we want a cache --

Disks are slow and files are getting larger by the day.

We can do a lot better than scanning a whole file.  A mechanism
that can notify programs about what file changed and what byte
range in the file changed can reduce scanning overhead by only
needing to scan the part of the file that changed.

More importantly, getting info on which bytes in a file changed
will also help backup programs and disk indexing programs.


Blocking on open can be useful for more than just anti-virus
scanning.  It can also be useful for hierarchical storage
management or simply for using a filesystem while it is being 
restored from backup - an important consideration because
restoring a filesystem from backup can take days with modern
data sizes.

Blocking on exec is similar to blocking on open and useful
in the same scenarios.


What we need to work on is making sure that the interfaces
that go into the kernel are useful not just for anti-virus
programs, but also for other software.

-- 
All Rights Reversed
