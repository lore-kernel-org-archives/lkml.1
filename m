Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZGJVo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZGJVo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 17:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZGJVoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 17:44:18 -0400
Received: from mail2.shareable.org ([80.68.89.115]:39061 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZGJVoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 17:44:17 -0400
Date: Fri, 10 Jul 2009 22:44:07 +0100
From: Jamie Lokier <jamie@shareable.org>
To: tridge@samba.org
Cc: Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090710214407.GC30322@shareable.org>
References: <87hbxu60qm.fsf@devron.myhome.or.jp> <19021.23231.213863.726785@samba.org> <alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr> <19021.26102.80885.330380@samba.org> <alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr> <19021.31291.642416.956966@samba.org> <alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr> <19021.63615.450348.192109@samba.org> <20090706200431.GC13638@shareable.org> <19028.19210.992993.643974@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19028.19210.992993.643974@samba.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org wrote:
> Hi Jamie,
> 
>  > I think it's ok to break that compatibility if dualnames is off,
>  > because that's unfortunately the best available compromise.
> 
> You probably noticed this, but the patch that has been put in only
> changes the shortname setting when dualnames is off.

Yes, I noticed.

What I mean is if I do this, with your patch active:

    mount /dev/sdb -t vfat -o shortname=mixed

(or shortname=lower, or shortname=win95), then it's wrong to override
my shortname request "shortname=mixed", because my request means "I
need lower-case names to _appear_ lower-case on something with Windows
95-like behaviour.

When dual names cannot be created, if I specify any shortname= option
except shortname=winnt, I'd rather create a long name entry for
lower-case 8.3 names than a short name.

That's why dualnames off should change the *default* to
shortname=winnt, but not override an explicit shortname= option.

With dualnames on, the default should be shortname=mixed because that
has wider compatibility, and it's like the old Linux default when
creating names.

-- Jamie
