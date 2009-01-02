Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbZABFTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbZABFTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 00:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZABFTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 00:19:22 -0500
Received: from mail.fieldses.org ([141.211.133.115]:52679 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZABFTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 00:19:21 -0500
Date: Fri, 2 Jan 2009 00:19:05 -0500
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by
	sys_faccessat() [ver #2]
Message-ID: <20090102051905.GC1073@fieldses.org>
References: <20090101235332.GA31840@fieldses.org> <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com> <29449.1230859152@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29449.1230859152@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 01:19:12AM +0000, David Howells wrote:
> J. Bruce Fields <bfields@fieldses.org> wrote:
> 
> > Hm.  newpynfs is also giving me failures having to do with the v4
> > server's permissions-checking.  I'll investigate, but is it possible
> > nfsd also needs a fix?
> 
> It's possible.  Have you seen whether this patch fixes those failures also?
> nfsd uses this facility also.

No.  I started bisecting, and it does appear to be a regression from the
cred patches, but at some point in the middle there it hangs on boot (a
softlockup report blames a spinlock in set_groups).

--b.
