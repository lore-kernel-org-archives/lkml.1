Return-Path: <linux-kernel-owner+w=401wt.eu-S1750898AbYD1GWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898AbYD1GWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYD1GWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:22:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53037 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbYD1GWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:22:16 -0400
Date: Mon, 28 Apr 2008 07:22:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] autofs4 - use lookup access intent to support
	recursive bind mounts
Message-ID: <20080428062213.GB5882@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0804281410160.10684@raven.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804281410160.10684@raven.themaw.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 02:14:54PM +0800, Ian Kent wrote:
> 
> Hi Andrew,
> 
> For autofs maps that recursively reference other map entries in their
> mount point path we need to ensure that these mounts are performed
> prior to the current mount request being done. We've used the access
> system call, made just prior to performing the mount, to make this
> happen. In the case of bind mounts, however, the lookup flags in 
> the path walk don't trigger a mount. To do this we need to also
> trigger a mount when we see the LOOKUP_ACCESS flag.

That's too fscking bad, since ->lookup() is about to lose access to
nameidata *and* flags for anything but the last step.  IOW, we'll need
cleaner solution...
