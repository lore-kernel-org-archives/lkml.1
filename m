Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbXFRHmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbXFRHmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 03:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbXFRHmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 03:42:14 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:48462 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756129AbXFRHmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 03:42:13 -0400
Subject: Re: [PATCH] diskquota: 32bit quota tools on 64bit architectures
From: Vasily Tarasov <vtaras@openvz.org>
Reply-To: vtaras@openvz.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, akpm@linux-foundation.org, dev@sw.ru,
       devel@openvz.org, jack@suse.cz, linux-kernel@vger.kernel.org,
       nataliep@google.com, vvs@sw.ru
In-Reply-To: <200706151724.17094.arnd@arndb.de>
References: <200706151003.l5FA3vd6008194@harpo.it.uu.se>
	 <200706151243.02186.arnd@arndb.de>
	 <1181918882.3241.48.camel@dhcp0-149.sw.ru>
	 <200706151724.17094.arnd@arndb.de>
Content-Type: text/plain
Organization: OpenVZ community
Date: Mon, 18 Jun 2007 11:41:12 +0400
Message-Id: <1182152472.4052.2.camel@dhcp0-248.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.0.1.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 17:24 +0200, Arnd Bergmann wrote:
> On Friday 15 June 2007, Vasily Tarasov wrote:
> > I just noticed that we can not avoid the addition of packed attribute.
> > Look, for example:
> > 
> > struct if_dqblk {
> >         __u64 dqb_bhardlimit; 
> >         __u64 dqb_bsoftlimit;
> >         __u64 dqb_curspace;
> >         __u64 dqb_ihardlimit;
> >         __u64 dqb_isoftlimit;
> >         __u64 dqb_curinodes; 
> >         __u64 dqb_btime;
> >         __u64 dqb_itime;
> >         __u32 dqb_valid;
> > };
> > 
> > sizeof(if_dqblk) = 0x48
> > On 32 bit: 0x44
> > 
> > If I replace __u64/__u32 with compat equivalents - it will not help!
> > alligned attribute can _only_ _increase_ the size of structure, but not
> > decrease it.
> 
> No, the gcc documentation isn't quite clear there, see the discussion about
> compat_u64 and compat_s64 types. It actually does the right thing when
> you use 'typedef __u64 __attribute__((aligned(64))) compat_64', as my
> patch does.
> 
> 	Arnd <><
> 

Wow!... Thank you for the explanation.
I'll resend the patch soon.

Vasily

