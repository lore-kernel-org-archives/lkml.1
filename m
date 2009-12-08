Return-Path: <linux-kernel-owner+w=401wt.eu-S966174AbZLHVIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966174AbZLHVIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:08:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966151AbZLHVH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:07:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52219
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965970AbZLHVH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:07:56 -0500
Date: Tue, 08 Dec 2009 13:08:02 -0800 (PST)
Message-Id: <20091208.130802.25121122.davem@davemloft.net>
To: hugh.dickins@tiscali.co.uk
Cc: viro@ZenIV.linux.org.uk, viro@ftp.linux.org.uk, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0912081254500.3365@sister.anvils>
References: <20091208060701.GM14381@ZenIV.linux.org.uk>
	<Pine.LNX.4.64.0912081142280.31223@sister.anvils>
	<Pine.LNX.4.64.0912081254500.3365@sister.anvils>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Date: Tue, 8 Dec 2009 13:03:30 +0000 (GMT)

> That would impose some (unacceptable?) limits, and require some funny
> code to migrate the pages over to the new mm later (instead of
> relocating within the new mm as we do now).

I think this approach would create new failure cases that don't exist
now.  Whether that's acceptable or not is another issue.

The forced page table move, and TLB+cache flush that goes along with
that, for every single compat task we get now on the other hand is not
acceptable :-)

I also think this page table move overhead is worse than the
non-swapability added by Al's approach.
