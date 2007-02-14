Return-Path: <linux-kernel-owner+w=401wt.eu-S1751131AbXBNGlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbXBNGlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 01:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbXBNGlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 01:41:07 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:62114 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXBNGlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 01:41:05 -0500
Date: Wed, 14 Feb 2007 07:42:08 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH debugfs: implement symbolic links
Message-ID: <20070214074208.0e2d1724@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070214013142.GB9023@suse.de>
References: <45D19D72.4050009@de.ibm.com>
	<20070213164551.500cd390@gondolin.boeblingen.de.ibm.com>
	<20070214013142.GB9023@suse.de>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 17:31:42 -0800,
Greg KH <gregkh@suse.de> wrote:

> > That makes it easy to get return code checking wrong (especially
> > considering the comment above), and a number of callers do get it wrong.
> 
> They do?

For example, fs/ocfs2/super.c only checks for NULL (while neither
selecting nor depending on debugfs), or drivers/block/pktcdvd.c will
only check for IS_ERR(). (Many callers don't seem to care about return
codes at all.)

> The goal here is not to force the caller to care if debugfs is enabled
> or not.

And that's definetly a good thing. (Looking again, not checking for
IS_ERR() isn't as bad as I thought, as the code will continue to do
nothing if called again for a non-existing dentry.)

> > At the very least we should change the misleading comment.
> 
> agreed, patches always welcome :)

OK, just changing the comment looks like the most sensible thing to do.
I'll roll up a patch.
