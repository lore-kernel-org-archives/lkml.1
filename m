Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbYD1Gj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbYD1Gj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbYD1GjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:39:16 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60216 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbYD1GjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:39:14 -0400
X-Sasl-enc: ZMRM182xtuMthk0TjRY7J0N4zQt9khrlToMI6rVrgKdS 1209364753
Subject: Re: [PATCH] autofs4 - use lookup access intent to support
	recursive bind mounts
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20080428062213.GB5882@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0804281410160.10684@raven.themaw.net>
	 <20080428062213.GB5882@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 14:38:25 +0800
Message-Id: <1209364705.3243.1.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-28 at 07:22 +0100, Al Viro wrote:
> On Mon, Apr 28, 2008 at 02:14:54PM +0800, Ian Kent wrote:
> > 
> > Hi Andrew,
> > 
> > For autofs maps that recursively reference other map entries in their
> > mount point path we need to ensure that these mounts are performed
> > prior to the current mount request being done. We've used the access
> > system call, made just prior to performing the mount, to make this
> > happen. In the case of bind mounts, however, the lookup flags in 
> > the path walk don't trigger a mount. To do this we need to also
> > trigger a mount when we see the LOOKUP_ACCESS flag.
> 
> That's too fscking bad, since ->lookup() is about to lose access to
> nameidata *and* flags for anything but the last step.  IOW, we'll need
> cleaner solution...

Spell it out for me please!
Ian

