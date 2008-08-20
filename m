Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbYHTHv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbYHTHv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 03:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYHTHvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 03:51:45 -0400
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:34935 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667AbYHTHvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 03:51:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=aczTnDg+UZHgK1bME1Tpz7aTTkfe4iOv3ehdrttIpg29xt/+YB6DzUmnXn5IInXJ;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Wed, 20 Aug 2008 03:51:30 -0400
From: Bill Fink <billfink@mindspring.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "David Witbrodt" <dawitbro@sbcglobal.net>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, netdev <netdev@vger.kernel.org>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user
 with the same regression
Message-Id: <20080820035130.38426b00.billfink@mindspring.com>
In-Reply-To: <86802c440808192221s3ada5443qc3b9d8e26f252d03@mail.gmail.com>
References: <109483.89278.qm@web82104.mail.mud.yahoo.com>
	<86802c440808192221s3ada5443qc3b9d8e26f252d03@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d474593ebeb0da981d73195954e698f31350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, Yinghai Lu wrote:

> On Tue, Aug 19, 2008 at 9:51 PM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
> > While reading drivers/char/hpet.c and looking at the functions
> > used there, I discovered request_region(), and realized that it
> > would be difficult to compare the entire iomem_resource tree to
> > a dummy tree only containing resources added by insert_resource()
> > and request_resource().  It might be simpler to have my tiny
> > e820_reserve_resources() replacement add each resource to 3 trees
> > -- the real iomem_resource tree, and 2 dummy trees -- which could
> > then be compared for differences just before the kernel locks up.
> 
> with reverting patch that change insert_resource to request_resource...
> 2.6.26 or 2.6.27-rcX still hange somewhere.

This is true if he reverted just the 3def3d6d... commit, but if he
also reverts the similar, and immediately following, 1e934dda...
commit, then his 2.6.26 kernel runs fine.

						-Bill
