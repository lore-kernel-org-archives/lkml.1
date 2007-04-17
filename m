Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbXDQMJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbXDQMJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 08:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbXDQMJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 08:09:39 -0400
Received: from mail.suse.de ([195.135.220.2]:33025 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbXDQMJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 08:09:36 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [nameidata 1/2] Don't pass NULL nameidata to vfs_create
Date: Tue, 17 Apr 2007 14:09:44 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Tony Jones <tonyj@suse.de>
References: <20070412090809.917795000@suse.de> <200704161840.41343.agruen@suse.de> <20070416164502.GA11762@infradead.org>
In-Reply-To: <20070416164502.GA11762@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2395
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704171409.45201.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007 18:45, Christoph Hellwig wrote:
> You should provide intent information, yes - which your patch didn't :)

Well, the information implicitly provided is "no intent": In do_create() in
ipc/mqueue.c intents would be pretty pointless because the mqueue filesystem
is local. In fs/nfsd/vfs.c, intents would make slightly more sense assuming
that the underlying filesystem eported via nfsd is remote. That's an
optimization, and not even a very important one.

> (Which btw, I expect to cause quite a few problems for apparmor or other
> lsms, but I guess so far no one has tried them on NFSv4)

Pathname wise, NFSv4 should look like any other filesystem on the client side. 
On the Server side, the concept of pathnames doesn't really fly for nfs: if a 
directory contains more than one link to the same file, there is no way to 
tell those aliases from each other from the file descriptor. In addition, 
computing even the somewhat ambiguous pathnames that can be computed would
require subtree checking. But trying to confine nfsd is pretty pointless 
anyway: the deamon is privileged and can do whatever it wants. It makes more
sense to export the right directories with the right permissions in the first
place.

Thanks,
Andreas
