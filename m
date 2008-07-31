Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYGaHbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYGaHbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 03:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYGaHbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 03:31:08 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41800 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbYGaHbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:31:07 -0400
To: jamie@shareable.org
CC: miklos@szeredi.hu, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-reply-to: <20080731001131.GA30900@shareable.org> (message from Jamie Lokier
	on Thu, 31 Jul 2008 01:11:31 +0100)
Subject: Re: [patch v3] splice: fix race with page invalidation
References: <20080731001131.GA30900@shareable.org>
Message-Id: <E1KOSbz-0007b6-0L@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 31 Jul 2008 09:30:11 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008, Jamie Lokier wrote:
> I'm more concerned by sendfile() users like Apache, Samba, FTPd.  In
> an earlier thread on this topic, I asked if the splice bug can also
> result in sendfile() sending blocks of zeros, when a file is truncated
> after it has been sent, and the answer was yes probably.
> 
> Not that I checked or anything.  But if it affects sendfile() it's a
> bigger deal - that has many users.

Nick also pointed out, that it also affects plain read(2), albeit only
with a tiny window.

But partial truncates are _rare_ (we don't even have a UNIX utility
for that ;), so in practice all this may not actually matter very
much.

Miklos
