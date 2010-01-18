Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288Ab0ARCdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab0ARCdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979Ab0ARCds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:33:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33957 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0ARCdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:33:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 18 Jan 2010 11:30:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       David Howells <dhowells@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
       <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 6/6] vfs: introduce FMODE_NEG_OFFSET for allowing
 negative f_pos
Message-Id: <20100118113026.4c6efd26.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <87y6jwjh3j.fsf@devron.myhome.or.jp>
References: <20100115013954.311049665@intel.com>
	<20100115014422.959401729@intel.com>
	<87bpgurz00.fsf@devron.myhome.or.jp>
	<20100118091527.7a0e2c6e.kamezawa.hiroyu@jp.fujitsu.com>
	<87y6jwnrcz.fsf@devron.myhome.or.jp>
	<20100118102544.3e897525.kamezawa.hiroyu@jp.fujitsu.com>
	<87pr58kx9o.fsf@devron.myhome.or.jp>
	<20100118110019.c55ad88a.kamezawa.hiroyu@jp.fujitsu.com>
	<87y6jwjh3j.fsf@devron.myhome.or.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 11:13:04 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> 
> > On Mon, 18 Jan 2010 10:38:27 +0900
> > OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
> >
> >> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> >> 
> >> >> So, lseek() returns (uses) it?
> >> >
> >> > lseek can return negative value, as far as I know.
> >> 
> >> Umm..., how do you know the difference of -EOVERFLOW and fpos == -75? 
> >> 
> >
> > Ah, sorry. I read wrong.
> >
> > For /dev/mem, it uses its own lseek function which allows negative f_pos
> > value. Other usual file system doesn't allow negative f_pos.
> >
> > It's ok not to return -EOVEFLOW for /dev/mem because there is no file end.
> 
> No, no. I think it has the problem.
> 
> E.g. /dev/mem returns -75 as fpos, so, lseek(2) returns -75 to
> userland. Then the userland (e.g. glibc) convert it as
> error. I.e. finally, errno == -75, and lseek(3) returns -1, right?
> 
Maybe possible.

Hmm. Then, /dev/mem's llseek need some fix not to return pos < -PAGESIZE.
Wu-san, could you add additional bug fix to lseek()'s f_pos handling in
/dev/mem ?

Thanks,
-Kame


