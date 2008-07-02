Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYGBNtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYGBNtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 09:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYGBNto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 09:49:44 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44956 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734AbYGBNto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:49:44 -0400
X-Sasl-enc: o5oxM0NTZGdKWeOeikU8k3Ha19galOk6WaCa2FPy962e 1215006582
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
Date: Wed, 02 Jul 2008 21:46:41 +0800
Message-Id: <1215006402.3046.72.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
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

A multi-mount that has no root mount gets a lookup for an offset that
doesn't exist (ie. the trigger hasn't been mounted). Then ->lookup()
will create a negative dentry and send a mount request to the daemon. It
is a bit of a special case but it helps a little.

Ian


