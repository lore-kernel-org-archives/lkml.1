Return-Path: <linux-kernel-owner+w=401wt.eu-S1750754AbXBMPov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750754AbXBMPov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbXBMPou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:44:50 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:36498 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbXBMPou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:44:50 -0500
Date: Tue, 13 Feb 2007 16:45:51 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH debugfs: implement symbolic links
Message-ID: <20070213164551.500cd390@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <45D19D72.4050009@de.ibm.com>
References: <45D19D72.4050009@de.ibm.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 12:13:54 +0100,
Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

Not especially related to this patch (which just does the same as the
other debugfs functions), but:

> + * If debugfs is not enabled in the kernel, the value -%ENODEV will be
> + * returned.  It is not wise to check for this value, but rather, check for
> + * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
> + * code.

does not look like good advice for return code handling. Return code
seems to be:

- ERR_PTR(-ENODEV) if debugfs is disabled
- NULL if debugfs is enabled and something went wrong
- !NULL and !IS_ERR if debugfs is enabled and all went fine

That makes it easy to get return code checking wrong (especially
considering the comment above), and a number of callers do get it wrong.

How about changing the return code behaviour of the debugfs code, either

1. return NULL if debugfs is disabled or something went wrong, !NULL
   else or
2. return ERR_PTR(-ENODEV) if debugfs is disabled, ERR_PTR(-ESOMEERROR)
   if something went wrong or a proper dentry if everything went fine?

At the very least we should change the misleading comment.

-- 
Cornelia Huck
Linux for zSeries Developer
Tel.: +49-7031-16-4837, Mail: cornelia.huck@de.ibm.com
