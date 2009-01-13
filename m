Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbZAMX0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbZAMX0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbZAMXZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:25:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910AbZAMXZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:25:55 -0500
Date: Tue, 13 Jan 2009 15:24:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mtk.manpages@gmail.com
Cc: mtk.manpages@googlemail.com, roland@redhat.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com, vegard.nossum@gmail.com, linux-man@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] sys_waitid: return -EFAULT for NULL
Message-Id: <20090113152457.0d7685ad.akpm@linux-foundation.org>
In-Reply-To: <cfd18e0f0901131514i2f7be7f1t2c6275c26dbb6874@mail.gmail.com>
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>
	<cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
	<20090113224759.7DFB7FC3DD@magilla.sf.frob.com>
	<20090113224941.36F19FC3DD@magilla.sf.frob.com>
	<cfd18e0f0901131514i2f7be7f1t2c6275c26dbb6874@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 12:14:20 +1300
"Michael Kerrisk" <mtk.manpages@googlemail.com> wrote:

> On Wed, Jan 14, 2009 at 11:49 AM, Roland McGrath <roland@redhat.com> wrote:
> > It's always been invalid to call waitid() with a NULL pointer.  It was an
> > oversight that it was allowed (and acts like a wait4() call instead).
> >
> > Signed-off-by: Roland McGrath <roland@redhat.com>
> 
> Modulo the observation that this change will break any Linux-specific
> application that violate POSIX.1's requirement that infop not be NULL
> (*), and rely on the existing Linux behavior for
> waitd(idtype,id,NULL,options):
> 

Well yes.  waitid() has been in there since 2.6.9.  I assume that it
has had this wait4-emulation mode for that amount of time as well?

> 
> (*) It seems unlikely that such applications exist, and we really
> should make this change for POSIX.1 conformance.

Well, we might get away with it.  But formally speaking, we should live
with our Linux-specific screwup.

If we _are_ going to make this change then we should merge it as far
back in -stable as we can, to reduce the risk that people will develop
applications on kernel version A only to have then behave differently
on version B.

