Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbZFWNho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbZFWNho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759553AbZFWNha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:37:30 -0400
Received: from host153.190-137-116.telecom.net.ar ([190.137.116.153]:34195
	"EHLO burns.springfield.home" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759569AbZFWNh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:37:28 -0400
X-Greylist: delayed 2525 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 09:37:27 EDT
Date: Tue, 23 Jun 2009 09:55:16 -0300
From: Leandro Lucarella <llucax@gmail.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, albertito@blitiri.com.ar, users@nilfs.org
Subject: Re: NILFS2 get stuck after bio_alloc() fail
Message-ID: <20090623125515.GB6345@homero.springfield.home>
References: <20090614153256.GA4020@homero.springfield.home> <20090615.030245.104791670.konishi.ryusuke@gmail.com> <20090614181313.GA16597@homero.springfield.home> <20090623.134026.08265083.ryusuke@osrg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623.134026.08265083.ryusuke@osrg.net>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryusuke Konishi, el 23 de junio a las 13:40 me escribiste:
> Hi Leandro,
> On Sun, 14 Jun 2009 15:13:13 -0300, Leandro Lucarella <llucax@gmail.com> wrote:
> > Ryusuke Konishi, el 15 de junio a las 03:02 me escribiste:
> > [snip]
> > > > Here is the complete trace:
> > > > http://pastebin.lugmen.org.ar/4931
> > > 
> > > Thank you for your help.
> > > 
> > > According to your log, there seems to be a leakage in clear processing
> > > of the writeback flag on pages.  I will review the error path of log
> > > writer to narrow down the cause.
> > 
> > Oh! I forgot to tell you that the cleanerd process was not running. When
> > I mounted the NILFS2 filesystem the cleanerd daemon said:
> > 
> > nilfs_cleanerd[29534]: start
> > nilfs_cleanerd[29534]: cannot create cleanerd on /dev/loop0
> > nilfs_cleanerd[29534]: shutdown
> > 
> > I thought I might have an old utilities version and that could be because
> > of that (since the nilfs website was down I couldn't check), but now
> > I checked in the backup nilfs website that latest version is 2.0.12 and
> > I have that (Debian package), so I don't know why the cleanerd failed to
> > start in the first place.
> 
> At the last weekend, several users gave me feedback on the same early
> failure of cleanerd process.
> 
> This problem turned out to be caused by an elementaly bug in the
> userland library of nilfs; there was a lack of canonicalization of
> pathname in the library, and it caused the failure, for example, when
> user adds an extra slash symbol to the mount directory name.
> 
> We have released nilfs2-utils-2.0.13 yesterday to resolve this mess.
> If you didn't know it, please try the updated package.

Ok, thanks for your help. I'll try the new nilfs-utils and the patch you
sent when I have some time and report the results.

-- 
Leandro Lucarella (luca) | Blog colectivo: http://www.mazziblog.com.ar/blog/
----------------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
