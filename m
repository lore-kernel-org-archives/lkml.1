Return-Path: <linux-kernel-owner+w=401wt.eu-S1752129AbZFWEkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbZFWEkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbZFWEkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:40:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:58688 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbZFWEkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:40:42 -0400
Date: Tue, 23 Jun 2009 13:40:26 +0900 (JST)
Message-Id: <20090623.134026.08265083.ryusuke@osrg.net>
To: llucax@gmail.com
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       albertito@blitiri.com.ar, users@nilfs.org
Subject: Re: NILFS2 get stuck after bio_alloc() fail
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20090614181313.GA16597@homero.springfield.home>
References: <20090614153256.GA4020@homero.springfield.home>
	<20090615.030245.104791670.konishi.ryusuke@gmail.com>
	<20090614181313.GA16597@homero.springfield.home>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 23 Jun 2009 13:40:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leandro,
On Sun, 14 Jun 2009 15:13:13 -0300, Leandro Lucarella <llucax@gmail.com> wrote:
> Ryusuke Konishi, el 15 de junio a las 03:02 me escribiste:
> [snip]
> > > Here is the complete trace:
> > > http://pastebin.lugmen.org.ar/4931
> > 
> > Thank you for your help.
> > 
> > According to your log, there seems to be a leakage in clear processing
> > of the writeback flag on pages.  I will review the error path of log
> > writer to narrow down the cause.
> 
> Oh! I forgot to tell you that the cleanerd process was not running. When
> I mounted the NILFS2 filesystem the cleanerd daemon said:
> 
> nilfs_cleanerd[29534]: start
> nilfs_cleanerd[29534]: cannot create cleanerd on /dev/loop0
> nilfs_cleanerd[29534]: shutdown
> 
> I thought I might have an old utilities version and that could be because
> of that (since the nilfs website was down I couldn't check), but now
> I checked in the backup nilfs website that latest version is 2.0.12 and
> I have that (Debian package), so I don't know why the cleanerd failed to
> start in the first place.

At the last weekend, several users gave me feedback on the same early
failure of cleanerd process.

This problem turned out to be caused by an elementaly bug in the
userland library of nilfs; there was a lack of canonicalization of
pathname in the library, and it caused the failure, for example, when
user adds an extra slash symbol to the mount directory name.

We have released nilfs2-utils-2.0.13 yesterday to resolve this mess.
If you didn't know it, please try the updated package.

Thanks,
Ryusuke Konishi

