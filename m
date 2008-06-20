Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbYFTN0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbYFTN0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYFTN0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:26:07 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33816 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755856AbYFTN0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:26:06 -0400
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2008 09:26:06 EDT
X-Sasl-enc: 4VGvcbKI17MgXklNRyf+64bp1eQf9ix106jBhrSRRGDD 1213967583
Subject: Re: [PATCH] autofs4 - detect invalid direct mount requests
From: Ian Kent <raven@themaw.net>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <x49iqw4tg63.fsf@segfault.boston.devel.redhat.com>
References: <20080620051301.9988.94307.stgit@raven.themaw.net>
	 <x49iqw4tg63.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain
Date: Fri, 20 Jun 2008 21:12:12 +0800
Message-Id: <1213967533.2971.98.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-06-20 at 09:00 -0400, Jeff Moyer wrote:
> Ian Kent <raven@themaw.net> writes:
> 
> > autofs v5 dierct and offset mounts within an autofs filesystem are
> > triggered by existing autofs triger mounts so the mount point dentry
> > must be positive. If the mount point dentry is negative then the
> > trigger doesn't exist so we can return fail immediately.
> 
> What are the conditions that lead us here in that case?

v5 doesn't need to get those dir/otherdir messages that we can't avoid
for v4.

Basically, attempts to access a non-existent directory in multi-mount
tree leads to a negative dentry being sent to the wait queue, but v5
direct and offset mounts must always have an existing (non-negative
dentry) directory upon which to mount. This is only relevant for
multi-mounts that don't have an explicit multi-mount root so that the
lookups occur within the autofs file system.

Sorry, I still can't think of a way to avoid this for v4.

Ian


