Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbXE2DTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbXE2DTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 23:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbXE2DT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 23:19:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49950 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbXE2DT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 23:19:28 -0400
Message-ID: <465B9BB9.7060300@garzik.org>
Date: Mon, 28 May 2007 23:19:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de,
       nfs@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [NFS] [PATCH] NFSD: fix uninitialized variable
References: <20070527103442.GA10594@havoc.gtf.org> <20070529030050.GB20631@fieldses.org>
In-Reply-To: <20070529030050.GB20631@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Sun, May 27, 2007 at 06:34:42AM -0400, Jeff Garzik wrote:
>> Unlike many of the bogus warnings spewed by gcc, this one actually
>> complains about a real bug:
> 
> No, the calls to posix_acl_valid() in nfs4_acl_posix_to_nfsv4() ensure
> that the passed-in acl has ACL_USER_OBJ, ACL_GROUP_OBJ, and ACL_OTHER
> entries, and hence that these fields will always be initialized.

OK


> But I don't want anyone else wasting their time on this.  Should we cave
> in and add the initialization here just to shut up gcc?  Or would a
> comment here help?

Given what you said above, I don't see gcc, on its best day, will ever 
know enough to validate that that variable is indeed always initialized. 
  So I would vote for silencing it on those grounds.

	Jeff


