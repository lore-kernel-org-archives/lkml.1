Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbXKFOLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbXKFOLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbXKFOLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:11:03 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42837 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751000AbXKFOLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:11:01 -0500
Date: Tue, 6 Nov 2007 15:10:37 +0100
From: Adrian Bunk <bunk@kernel.org>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org,
       torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071106141037.GL26163@stusta.de>
References: <20071103164303.GA26707@ubuntu> <20071106063305.GA26163@stusta.de> <C1C917F8-57EA-434C-9FD8-CB5A4EAF2653@mac.com> <20071106085651.GC26163@stusta.de> <20071106113359.GA6041@ubuntu> <20071106114738.GH26163@stusta.de> <1865922a0711060423ue81dbdct413b993e727f6f9@mail.gmail.com> <46B300CD-7A35-4E81-A0AE-EC2BB72016DD@mac.com> <20071106133446.GI26163@stusta.de> <20071106140504.GA6310@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071106140504.GA6310@ubuntu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 04:05:13PM +0200, Ahmed S. Darwish wrote:
> On Tue, Nov 06, 2007 at 02:34:46PM +0100, Adrian Bunk wrote:
> > On Tue, Nov 06, 2007 at 07:49:26AM -0500, Kyle Moffett wrote:
> > > On Nov 06, 2007, at 07:23:36, Ahmed S. Darwish wrote:
> > >> On 11/6/07, Adrian Bunk <bunk@kernel.org> wrote:
> > >>> On Tue, Nov 06, 2007 at 01:34:05PM +0200, Ahmed S. Darwish wrote:
> > >>>> As far as I understand the problem now, isspace() accepts the 0xa0 
> > >>>> character which might collide with some of UTF-8 encoded characters 
> > >>>> cause the high bit is set.
> > >>
> > >> I admit I'm not experienced in such encoding stuff, but shouldn't the 
> > >> ASCII and the ASCII-compatible UTF-8 encodings be enough for the labels?
> > >>
> > >>> It would not work if someone would e.g. give you UTF-16 encoded strings, 
> > >>> but I don't see this happening in practice.
> > >>
> > >> Won't this complicate the code too much ?
> > >
> > > Well the VFS (for example) certainly doesn't support any encodings other 
> > > than various extended-ASCII forms (which includes UTF-8).  Something like 
> > > UTF-16 has extra null characters in-between every normal character, and as 
> > > such would fail completely if passed to the VFS.
> > 
> > Good point.
> > 
> > > Personally I think that isspace() accepting character 0xA0 is a bug, as 
> > > there are several variants of extended ASCII only one of which has that 
> > > character as a space.  Others have it as ?? (accented A), etc.
> > 
> > But even then Smack would still have a similar problem with isgraph().
> > 
> 
> Great, To summarize the discussion. Will there be a problem in 
> accepting ASCII and the UTF-8 ASCII _subset_ _only_ and  return 
> -EINVAL for all other cases/ecnodings ?.

The UTF-8 ASCII subset is the complete ASCII.

> i.e. The fragment I sent in a previous message:
> 
> /* Filter UTF-8 non-ascii compatible bytes (> 0x7F) */
> if (!isascii(c)) return -EINVAL; 
> /* Filter unwanted ascii chars */
> if (!isspace(c) && !isgraph(c)) return -EINVAL; 
>...

As I already said, this should work fine.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

