Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbZKPIeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbZKPIeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 03:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZKPIeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 03:34:16 -0500
Received: from nox.protox.org ([88.191.38.29]:50394 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbZKPIeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 03:34:15 -0500
Subject: Re: [PATCH 2/2] drm: mm always protect change to unused_nodes with
  unused_lock spinlock
From: Jerome Glisse <glisse@freedesktop.org>
To: Dave Airlie <airlied@gmail.com>
Cc: dri-devel@lists.sf.net, LKML <linux-kernel@vger.kernel.org>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <21d7e9970911151542n49f15a9dn6481d0bc2bdfbc45@mail.gmail.com>
References: <1258142218-2070-1-git-send-email-jglisse@redhat.com>
	 <21d7e9970911151542n49f15a9dn6481d0bc2bdfbc45@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Nov 2009 09:31:34 +0100
Message-Id: <1258360294.1989.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-16 at 09:42 +1000, Dave Airlie wrote:
> On Sat, Nov 14, 2009 at 5:56 AM, Jerome Glisse <jglisse@redhat.com> wrote:
> > unused_nodes modification needs to be protected by unused_lock spinlock.
> > Here is an example of an usage where there is no such protection without
> > this patch.
> >
> >  Process 1: 1-drm_mm_pre_get(this function modify unused_nodes list)
> >             2-spin_lock(spinlock protecting mm struct)
> >             3-drm_mm_put_block(this function might modify unused_nodes
> >               list but doesn't protect modification with unused_lock)
> >             4-spin_unlock(spinlock protecting mm struct)
> >  Process2:  1-drm_mm_pre_get(this function modify unused_nodes list)
> > At this point Process1 & Process2 might both be doing modification to
> > unused_nodes list. This patch add unused_lock protection into
> > drm_mm_put_block to avoid such issue.
> 
> Have we got a bug number or reproducer for this?
> 
> I've cc'ed Thomas and Chris who were last ppl to touch drm_mm.c for some
> sort of acks.
> 
> Dave.

No bug, this comes from code review while working on TTM. I think my
analysis is correct.

Cheers,
Jerome

