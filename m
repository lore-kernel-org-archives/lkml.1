Return-Path: <linux-kernel-owner+w=401wt.eu-S1763509AbXGFWil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763509AbXGFWil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbXGFWie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:38:34 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:60631 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760001AbXGFWid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:38:33 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Date: Sat, 7 Jul 2007 00:38:25 +0200
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org
References: <20070706202629.GA158@tv-sign.ru>
In-Reply-To: <20070706202629.GA158@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707070038.25830.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 6. Juli 2007 schrieb Oleg Nesterov:
> Rafael J. Wysocki wrote:
> >
> > This patch makes the freezer skip uninterruptible user space tasks (ie. such
> > that have an mm of their own) when counting the tasks to be frozen.  As a
> > result, these tasks have the TIF_FREEZE and TIF_SIGPENDING flags set, but the
> > freezer doesn't wait for them to enter the refrigerator.  Nevertheless, they
> > will enter the refrigerator as soon as they change their state.
> 
> A small correction: they will enter the refrigerator on return to user-space.

That is too late. We would need them to go to sleep as soon as they are
woken up. This does not matter if they are in uninterruptible sleep due to
fuse deadlocking, as they won't be woken up, but it kills the other cases.

	Regards
		Oliver
