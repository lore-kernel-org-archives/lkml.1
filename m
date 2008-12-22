Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYLVJCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYLVJCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 04:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYLVJBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 04:01:54 -0500
Received: from tservice.net.ru ([195.178.208.66]:34511 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbYLVJBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 04:01:54 -0500
Date: Mon, 22 Dec 2008 12:01:49 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Eric Paris <eparis@redhat.com>
Cc: "C. Scott Ananian" <cscott@laptop.org>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, viro@zeniv.linux.org.uk, hch@infradead.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC PATCH -v4 12/14] fsnotify: add correlations between events
Message-ID: <20081222090149.GA22123@ioremap.net>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com> <20081212215217.27112.75137.stgit@paris.rdu.redhat.com> <c6d9bea0812181428s2ae78e30y1e700b2eca07ca96@mail.gmail.com> <1229913601.29604.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229913601.29604.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 09:40:01PM -0500, Eric Paris (eparis@redhat.com) wrote:
> anyone who uses inotify think there would be a problem with cookie reuse
> coming this soon?

In my experience we only care about cookies to be the same, and not
monotinically grow up. So this may just jump up and down, and since
events are potentially distributed in time (although follow one after
another), wrapping should roughly cover number of processes running (and
potentially renaming objects), so having 20 bits for the counter and 12
for the CPU id should be enough for now.

-- 
	Evgeniy Polyakov
