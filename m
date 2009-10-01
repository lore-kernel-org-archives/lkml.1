Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZJATen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZJATen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZJATem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:34:42 -0400
Received: from [76.245.85.235] ([76.245.85.235]:58143 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbZJATel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:34:41 -0400
X-Greylist: delayed 2653 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2009 15:34:41 EDT
Date: Thu, 1 Oct 2009 11:49:35 -0700
From: Brad Boyer <flar@allandria.com>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Union mounts/writable overlays design
Message-ID: <20091001184935.GA27667@cynthia.pants.nu>
References: <20091001145547.GA29152@shell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001145547.GA29152@shell>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 10:55:48AM -0400, Valerie Aurora wrote:
> We need to guarantee that a file system will be read-only for as long
> as it is the bottom layer of a writable overlay.  To do this, we track
> the number of "read-only users" of a file system in its VFS superblock
> structure.  When we mount a writable overlay over a file system, we
> increment its read-only user count.  The file system can only be
> mounted read-write if its read-only users count is zero.
> 
> Todo:
> 
> - Support really really read-only NFS mounts.  See discussion here:
> 
>   http://markmail.org/message/3mkgnvo4pswxd7lp

Is there any way for a file system driver to just come out and say
"I can't guarantee that this mount is really read-only"? I can imagine
this might be an issue for things other than NFS. I think it would be
worthwhile to have a flag maybe on a per sb level that says that even
if it is mounted with the "ro" option that it might not really be stable.
I don't think this is essential, but it would be a good feature as long
as it doesn't damage the design or performance too much.

	Brad Boyer
	flar@allandria.com

