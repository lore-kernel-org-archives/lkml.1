Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYDXDSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYDXDSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 23:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYDXDSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 23:18:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51266
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752281AbYDXDSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 23:18:45 -0400
Date: Wed, 23 Apr 2008 20:18:44 -0700 (PDT)
Message-Id: <20080423.201844.167236025.davem@davemloft.net>
To: vapier@gentoo.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] linux/atm_tcp.h: cleanup for userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <200804232303.52427.vapier@gentoo.org>
References: <1208661754-3197-1-git-send-email-vapier@gentoo.org>
	<20080423.192418.188020745.davem@davemloft.net>
	<200804232303.52427.vapier@gentoo.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 23 Apr 2008 23:03:51 -0400

> On Wednesday 23 April 2008, David Miller wrote:
> > From: Mike Frysinger <vapier@gentoo.org>
> > > The atm_tcp.h uses types from linux/atm.h, but does not include it.  It
> > > should also use the standard __u## types from linux/types.h rather than
> > > the uint##_t types since the former can be found with the kernel already.
> > >
> > > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >
> > I don't think this is a sufficient patch to solve these problems.
> 
> it is sufficient for atm_tcp.h only.  many of the network headers are broken 
> for userspace inclusion, so i've just been posting them one at a time as last 
> time i posted a large patch, no one picked it up.

But you're adding an include of another file that has the problem
you're supposedly fixing.

If using uintN_t types is the problem, you're adding a new one for
applications that include linux/atm_tcp.h, because now they'll
get linux/atm.h as a side effect which does it too.
