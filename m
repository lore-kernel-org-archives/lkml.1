Return-Path: <linux-kernel-owner+w=401wt.eu-S1763522AbYBSWe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763522AbYBSWe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761251AbYBSWd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:33:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:60981 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbYBSWdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:33:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [PATCH 2.6.24] block2mtd: removing a device and typo fixes
Date: Tue, 19 Feb 2008 23:33:38 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
References: <chaz20080212134751.GI30304@artesyncp.com> <chaz20080212161034.GJ30304@artesyncp.com> <20080219150822.GA29587@lazybastard.org>
In-Reply-To: <20080219150822.GA29587@lazybastard.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
Cc: Stephane Chazelas <stephane.chazelas@emerson.com>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802192333.39707.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Zj1YHBk9ivbvgFRliQl7R4AGZuu5+K+973wX
 Hm39JyV9VN1SU9NsHNLmqV1pPQyYDuI+LZEsAGoIc0L3SpWPWD
 ZcxSuhGswHrH8K3FlWyww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008, you wrote:
> > What about having a /dev/block2mtd (with owner/permissions that
> > could allow non-root users to use it), with 2 ioctls:
> > 
> > - one to "link" a block dev to a mtd that would take as
> >   parameter a fd to an open block dev (again allowing for
> >   flexible permissions) and would return the number of the
> >   allocated mtd and success/failure in errno. Upon sucess it
> >   would increase the refcnt of block2mtd.
> > 
> > - and one to "release" the link. That would fail if the mtd is
> >   in use and decrease block2mtd's refcnt upon success.
> > 
> > A bit like the loop devices (or /dev/ptmx) actually. What do you
> > think?
> 
> Could work.  Passing the fd raises several alarm bells.  Arnd, any
> comments from you?

Given that loop works in this way, I certainly see that as doable,
but then I'd vote for using the existing ioctl semantics of
LOOP_SET_FD and LOOP_DEL_FD on the mtdchar device, which already
comes with an ioctl interface for mtd devices.
I'd probably also allow the LOOP_{GET,SET}_STATUS{,64} commands,
so you can actually use the existing losetup tool.
That way, we wouldn't have to introduce a new API, just extend
an existing one to work on more things.

	Arnd <><
