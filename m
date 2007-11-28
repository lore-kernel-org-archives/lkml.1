Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbXK1Uwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbXK1Uwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756681AbXK1Uwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:52:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:60392 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbXK1Uwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:52:36 -0500
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before
	kobject_init
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0711281532150.2729-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711281532150.2729-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 21:52:30 +0100
Message-Id: <1196283150.3242.131.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/exzpuLid7/WMS3aO2f8n4Ke5deaPOAJwCYkg
 Y13XlQ3cI7YQ/WeI6oMbnTjXRI4ZPFXXbWBNjD4pvYi/Gwq05Y
 jSSOBxRHeazbcb9FQI0tbH4Knr1Ac7l
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-28 at 15:42 -0500, Alan Stern wrote:
> This patch (as1020) adds a check to kobject_init() to insure that the
> ktype field is not NULL.

That's good.

> This is just for safety's sake; as far as I
> know there are no remaining places where the field is left unset.  But
> ironically, kset_init() did fail to set it!

Nice to have that fixed.

> The patch fixes that and
> removes some redundant initialization in kset_createa().
> 
> The patch also fixes up elevator_init(), where ktype was set after
> calling kobject_init() instead of before.

It should not harm, only the kset was needed before _init(), but even
that should be history with Greg's latest patch:
http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=driver/kobject-grab-the-kset-reference-in-kobject_add-not-kobject_init.patch;hb=HEAD

> Here is the check we discussed.  I'm a little behind on Kay's most 
> recent updates; I hope this doesn't clash with them.
> 
> There may be some other places where ktype gets set after 
> kobject_init() rather than before.  My testing can't be termendously 
> thorough.  But they should all be easy to fix (like elevator.c was)

I think it's fine and elevator does not need to be changed, and we can
remove the requirement now from the documentation, as _init() now does
not depend on any pre-assigned values, right?

Kay

