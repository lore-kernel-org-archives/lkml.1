Return-Path: <linux-kernel-owner+w=401wt.eu-S936174AbXFGEx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936174AbXFGEx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 00:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbXFGExV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 00:53:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:62990 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbXFGExU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 00:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qnKChYfGSmYzDQWsXQ7UOOSNZVNngIjt1WMlnJQzQFJrypZsIklsB9Azszaqtqj4FrWbYL2rulVHP7PgFb+I6rcIEcy9/MK2fpwx5sV8U8C5S6m9n73CKJU6vGF31SZTebTWgt2cpe/cQcbIH24p6sFRECDIM/9c/ZRGDCjtPRM=
Message-ID: <787b0d920706062153u7ad64179p1c4f3f663c3882f@mail.gmail.com>
Date: Thu, 7 Jun 2007 00:53:19 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] /proc/pid/maps doesn't match "ipcs -m" shmid
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ebiederm@xmission.com,
       pbadari@us.ibm.com, torvalds@linux-foundation.org
In-Reply-To: <20070606204432.b670a7b1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com>
	 <20070606204432.b670a7b1.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 6 Jun 2007 23:27:01 -0400 "Albert Cahalan" <acahalan@gmail.com> wrote:
> > Eric W. Biederman writes:
> > > Badari Pulavarty <pbadari@us.ibm.com> writes:
> >
> > >> Your recent cleanup to shm code, namely
> > >>
> > >> [PATCH] shm: make sysv ipc shared memory use stacked files
> > >>
> > >> took away one of the debugging feature for shm segments.
> > >> Originally, shmid were forced to be the inode numbers and
> > >> they show up in /proc/pid/maps for the process which mapped
> > >> this shared memory segments (vma listing). That way, its easy
> > >> to find out who all mapped this shared memory segment. Your
> > >> patchset, took away the inode# setting. So, we can't easily
> > >> match the shmem segments to /proc/pid/maps easily. (It was
> > >> really useful in tracking down a customer problem recently).
> > >> Is this done deliberately ? Anything wrong in setting this back ?
> > >
> > > Theoretically it makes the stacked file concept more brittle,
> > > because it means the lower layers can't care about their inode
> > > number.
> > >
> > > We do need something to tie these things together.
> > >
> > > So I suspect what makes most sense is to simply rename the
> > > dentry SYSVID<segmentid>
> >
> > Please stop breaking things in /proc. The pmap command relys
> > on the old behavior.
>
> What effect did this change have upon the pmap command?  Details, please.
>
> > It's time to revert.
>
> Probably true, but we'd need to understand what the impact was.

Very simply, pmap reports the shmid.

albert 0 ~$ pmap `pidof X` | egrep -2 shmid
30050000  16384K rw-s-  /dev/fb0
31050000    152K rw---    [ anon ]
31076000    384K rw-s-    [ shmid=0x3f428000 ]
310d6000    384K rw-s-    [ shmid=0x3f430001 ]
31136000    384K rw-s-    [ shmid=0x3f438002 ]
31196000    384K rw-s-    [ shmid=0x3f440003 ]
311f6000    384K rw-s-    [ shmid=0x3f448004 ]
31256000    384K rw-s-    [ shmid=0x3f450005 ]
312b6000    384K rw-s-    [ shmid=0x3f460006 ]
31316000    384K rw-s-    [ shmid=0x3f870007 ]
31491000    140K r----  /usr/share/fonts/type1/gsfonts/n021003l.pfb
3150e000   9496K rw---    [ anon ]
