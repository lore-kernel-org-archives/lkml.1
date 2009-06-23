Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZFWUNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZFWUNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZFWUM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:12:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288AbZFWUM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:12:58 -0400
Date: Tue, 23 Jun 2009 13:12:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
       ghaskins@novell.com, rusty@rustcorp.com.au, bcrl@kvack.org
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
Message-Id: <20090623131239.711d9f83.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
	<alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 12:25:36 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> Another cleanup this patch does, is making AIO select EVENTFD, instead of 
> adding a bunch of empty function stubs inside eventfd.h in order to 
> handle the (AIO && !EVENTFD) case.

Given that we're trying to squeak this patch into 2.6.31, it's quite
unfortunate to include unrelated changes.  Especially ones which
involve the always-problematic "select".  Although this one looks less
than usually deadly due to the simple dependencies of AIO and eventfd.

However...

Is this a good way of fixing the (AIO && !EVENTFD) case?  Surely if the
developer selected this combination, he doesn't want to carry the
overhead of including eventfd.  IOW, if AIO can work acceptably without
eventfd being compiled into the kernel then adding the stubs is a
superior solution.


