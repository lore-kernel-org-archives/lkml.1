Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbXB1U7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbXB1U7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXB1U73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:59:29 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:43428 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbXB1U72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:59:28 -0500
To: staubach@redhat.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <E1HMVWJ-00009K-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Wed, 28 Feb 2007 21:35:27 +0100)
Subject: Re: [patch 01/22] update ctime and mtime for mmaped write
References: <20070227231442.627972152@szeredi.hu> <20070227231544.519463073@szeredi.hu> <45E58EB8.6030502@redhat.com> <E1HMSGE-000886-00@dorka.pomaz.szeredi.hu> <45E5BA2E.8060003@redhat.com> <E1HMSy2-0008F6-00@dorka.pomaz.szeredi.hu> <45E5DF8E.80109@redhat.com> <E1HMVWJ-00009K-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1HMVt0-0000D2-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Feb 2007 21:58:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What happens if the application overwrites what it had written some
> time later?  Nothing.  The page is already read-write, the pte dirty,
> so even though the file was clearly modified, there's absolutely no
> way in which this can be used to force an update to the timestamp.

Which, I realize now, actually means, that the patch is wrong.  Msync
will have to write protect the page table entries, so that later
dirtyings may have an effect on the timestamp.

Thanks,
Miklos
