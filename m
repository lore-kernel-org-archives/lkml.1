Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZFWHuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZFWHuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZFWHuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:50:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZFWHuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:50:01 -0400
Date: Tue, 23 Jun 2009 00:49:39 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: David Howells <dhowells@redhat.com>
cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-cachefs] CacheFiles: Readpage failed on backing file
In-Reply-To: <alpine.DEB.2.01.0906221732120.6439@bogon>
Message-ID: <alpine.DEB.2.01.0906230041490.6439@bogon>
References: <alpine.DEB.2.01.0906211926080.6439@bogon> <6950.1245661098@redhat.com> <alpine.DEB.2.01.0906221732120.6439@bogon>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+W4RwpRjaImIPDBPDaIWkeEZ4dr3w66AT5H8l
 mKt15A7/F4CnQVcfNfBp8HAyfybVCKAskuGe9iGG5QrGhPbEXk
 YM6xyey0MgybOkj4pFTew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Christian Kujau wrote:
> On Mon, 22 Jun 2009, David Howells wrote:
> >> [  399.332346]  [<ffffffff810da03a>] ? ext3_truncate+0x26a/0x9e0
> > 
> > Can you try the attached patch, please?
> 
> The patch helps, I think. Without this patch I was able to reproduce 
> this very quickly, just running "grep -lr foo /share/nfs" was enough to
> trigger the backtrace. With this patch, grep is still running (and 
> utilizing cachefiles) but no warnings so far.

Unfortunately, now the system just freezes when doing *a lot* of read
operations on the NFS share (grep -r foo again). I don't know if it's 
related to your patch or something else, debugging is kinda hard at the 
moment, as it's a Xen DomU (no netconsole; serial redirection magic still 
not working), it'll take me a while to figure out what's going on here.

FWIW, I'm able to compile kernels over this very same (readonly) NFS 
share, only "grep -r" was able to trigger the freeze.

Thanks,
Christian.
-- 
BOFH excuse #323:

Your processor has processed too many instructions.  Turn it off immediately, do not type any commands!!
