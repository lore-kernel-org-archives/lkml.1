Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbYLPVF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbYLPVF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 16:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbYLPVFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:05:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51846 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbYLPVFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:05:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kyle McMartin <kyle@infradead.org>
Subject: Re: [PATCH v3 0/3] preadv & pwritev syscalls.
Date: Tue, 16 Dec 2008 22:03:05 +0100
User-Agent: KMail/1.9.9
Cc: Gerd Hoffmann <kraxel@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com> <4947DBFA.9050108@redhat.com> <20081216170209.GC410@bombadil.infradead.org>
In-Reply-To: <20081216170209.GC410@bombadil.infradead.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812162203.06139.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18I4v7wGRBtWCsimnsl+0QcRXJN779/WDrDk3O
 CD+Uu3HWjHZDDw2xdryp17KhiXNYSglmJBBoYmt0KvaeWdGUey
 28h2R6gQ2Yp/qVTG9Xwaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2008, Kyle McMartin wrote:
> > I'd prefer to have the ordering coded explicitly instead, like this:
> > 
> > asmlinkage int compat_sys_pwritev(unsigned long fd,
> >        const struct compat_iovec __user *vec, unsigned long vlen,
> >        unsigned pos_low, unsigned pos_high)
> > {
> >       loff_t pos = pos_low | (loff_t)pos_high << 32;
> >         [ ... ]
> > 
> 
> Sadly this isn't possible without a wrapper unless you can guarantee
> it was passed low high instead of high low. Unless you munge it in
> userspace, you can't.
> 

Exactly, we have to munge it in userspace anyway because of the
argument ordering requirement we get if we pass it as a single u64.
I vote for the explicit split as well, this will give us a straightforward
wrapper in user space, unlike the swapped arguments that are just asking
for trouble, and will make it easy to have a common compat_sys_pwritev
function.

	Arnd <><
