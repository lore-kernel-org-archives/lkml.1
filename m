Return-Path: <linux-kernel-owner+w=401wt.eu-S933079AbXCAHZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbXCAHZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933077AbXCAHZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:25:45 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:56050 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043AbXCAHZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:25:44 -0500
To: staubach@redhat.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <45E5EF89.4050707@redhat.com> (message from Peter Staubach on
	Wed, 28 Feb 2007 16:09:29 -0500)
Subject: Re: [patch 01/22] update ctime and mtime for mmaped write
References: <20070227231442.627972152@szeredi.hu> <20070227231544.519463073@szeredi.hu> <45E58EB8.6030502@redhat.com> <E1HMSGE-000886-00@dorka.pomaz.szeredi.hu> <45E5BA2E.8060003@redhat.com> <E1HMSy2-0008F6-00@dorka.pomaz.szeredi.hu> <45E5DF8E.80109@redhat.com> <E1HMVWJ-00009K-00@dorka.pomaz.szeredi.hu> <E1HMVt0-0000D2-00@dorka.pomaz.szeredi.hu> <45E5EF89.4050707@redhat.com>
Message-Id: <E1HMff6-0001es-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 01 Mar 2007 08:25:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> What happens if the application overwrites what it had written some
> >> time later?  Nothing.  The page is already read-write, the pte dirty,
> >> so even though the file was clearly modified, there's absolutely no
> >> way in which this can be used to force an update to the timestamp.
> >>     
> >
> > Which, I realize now, actually means, that the patch is wrong.  Msync
> > will have to write protect the page table entries, so that later
> > dirtyings may have an effect on the timestamp.
> 
> I thought that PeterZ's changes were to write-protect the page after
> cleaning it so that future modifications could be detected and tracked
> accordingly?  Does the right thing not happen already?

Yes, but MS_ASYNC does not clean the pages.

In fact a better solution may be to rely on the dirty bit in the page
tables, so that no more page faults are necessary.

Thanks,
Miklos
