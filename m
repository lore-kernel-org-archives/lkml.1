Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbXHSVnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbXHSVnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 17:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbXHSVmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 17:42:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbXHSVmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 17:42:24 -0400
Date: Sun, 19 Aug 2007 23:42:18 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Rene Herman <rene.herman@home.nl>
cc: 7eggert@gmx.de, Mike Mohr <akihana@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: group ownership of tun devices -- nonfunctional?
In-Reply-To: <46C86B6C.8090209@home.nl>
Message-ID: <Pine.LNX.4.58.0708192333170.2426@be1.lrz>
References: <8Tpwf-3Nb-1@gated-at.bofh.it> <E1IMnHK-00012c-VC@be1.lrz>
 <46C86B6C.8090209@home.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/K1WfTA4r7ml5bI1Qehnf5ig71GS90X0HmKVz
 zojT0MrsWh9tINM0iSYW0nqqLyCG/P+wRqpPujpEMe/pnqzH3x
 1/GM0kiTX2NoEfpa+DRTQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2007, Rene Herman wrote:

> On 08/19/2007 06:05 PM, Bodo Eggert wrote:
> 
> > IMHO the check is broken:
> > 
> > +               if (((tun->owner != -1 &&
> > +                     current->euid != tun->owner) ||
> > +                    (tun->group != -1 &&
> > +                     current->egid != tun->group)) &&
> > +                    !capable(CAP_NET_ADMIN))
> >                         return -EPERM;
> > 
> > It should be something like:
> > 
> > +               if (!((tun->owner == tun->owner) ||
> > +                     (tun->group == tun->group) ||
> 
> ???

Argh, I edited asuming the same order of variables. Substitute 
current->e{uid,gid} for one of the sides.

> > +                     capable(CAP_NET_ADMIN)))
> >                         return -EPERM;

The intended semantics is If the user is not
 * the allowed user
or
 * member of the allowed group
or
 * cabable of CAP_NET_ADMIN
then error out. I'm asuming  

Thinking about it, maybe you should check each group, not just the 
effective group. In that case, my change would be still wrong. However, 
I'm not going to fix this anytime soon.

-- 
Funny quotes:
15. I drive way too fast to worry about cholesterol.
