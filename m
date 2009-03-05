Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbZCEOnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbZCEOnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZCEOn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:43:28 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:36844 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbZCEOn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:43:27 -0500
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: drop_caches ...
Date: Thu, 5 Mar 2009 15:43:22 +0100
User-Agent: KMail/1.9.10
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Zdenek Kabelac <zkabelac@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>
References: <200903041057.34072.M4rkusXXL@web.de> <200903051505.26584.M4rkusXXL@web.de> <20090305142230.GA23465@localhost>
In-Reply-To: <20090305142230.GA23465@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903051543.22516.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX19kkHstzQmnecUn1uvXEUMGSWSE9IMN8RSRzOfD
	vv+POrVQu7oqaqubhF/45v2uXxMWDWBB0rjWSm6ri3mFyDnn3X
	N+Nwk+srQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Could you please try the attached patch which will also show the
> > > user and process that opened these files? It adds three more 
fields
> > > when CONFIG_PROC_FILECACHE_EXTRAS is selected.
> > > 
> > > Thanks,
> > > Fengguang
> > >  
> > > On Thu, Mar 05, 2009 at 01:55:35PM +0200, Markus wrote:
> > > > 
> > > > # sort -n -k 3 filecache-2009-03-05 | tail -n 5
> > > >      15886       7112     7112     100      1    d- 00:08
> > > > (tmpfs)        /dev/zero\040(deleted)
> > > >      16209      35708    35708     100      1    d- 00:08
> > > > (tmpfs)        /dev/zero\040(deleted)
> > > >      16212      82128    82128     100      1    d- 00:08
> > > > (tmpfs)        /dev/zero\040(deleted)
> > > >      15887     340024   340024     100      1    d- 00:08
> > > > (tmpfs)        /dev/zero\040(deleted)
> > > >      15884     455008   455008     100      1    d- 00:08
> > > > (tmpfs)        /dev/zero\040(deleted)
> > > > 
> > > > The sum of the third column is 1013 MB.
> > > > To note the biggest ones (or do you want the whole file?)... and 
> > thats 
> > > > after a sync and a drop_caches! (Can be seen in the commands 
given.)
> > 
> > I could, but I know where these things belong to. Its from sphinx (a 
> > mysql indexer) searchd. It loads parts of the index into memory.
> > The sizes looked well-known and killing the searchd will 
reduce "cached" 
> > to a normal amount ;)
> 
> And it's weird about the file name: /dev/zero.  I wonder how it
> managed to create that file, and then delete it, inside a tmpfs!

I dont know exactly. But in the source its just a:
... mmap ( NULL, m_iLength, PROT_READ | PROT_WRITE, MAP_SHARED | 
MAP_ANON, -1, 0 );
Perhaps thats the way shared anonymous memory is handled?!


> Just out of curiosity, are they shm objects? Can you show us the
> output of 'df'? In your convenient time.

Thats all:
# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md6               14G  7.9G  5.9G  58% /
udev                   10M  304K  9.8M   3% /dev
cachedir              4.0M  100K  4.0M   3% /lib64/splash/cache
/dev/md4               19G   15G  3.2G  82% /home
/dev/md3              8.3G  4.5G  3.8G  55% /usr/portage
shm                   2.0G     0  2.0G   0% /dev/shm


> > I just dont know why its in "cached" (can that be swapped out btw?).
> > But I think thats not a problem of the kernel, but of anonymous 
> > mmap-ing.
> 
> You know, because the file is created in tmpfs, which is swap-backed.
> By definition the pages here cannot be dropped by third-party.

Hm, ok.


> > I think its resolved, thanks to everybody and Fengguang in 
particular!
> 
> You are welcome :-)
;)

Have a nice day.
Markus
