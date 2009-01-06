Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbZAFQ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbZAFQ0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZAFQ0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:26:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57959
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbZAFQ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:26:18 -0500
Date: Tue, 06 Jan 2009 08:26:19 -0800 (PST)
Message-Id: <20090106.082619.170966508.davem@davemloft.net>
To: tytso@mit.edu
Cc: jbeulich@novell.com, sam@ravnborg.org, linux-kernel@vger.kernel.org,
       ccache@lists.samba.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1LKDeQ-0002xz-7E@closure.thunk.org>
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Theodore Ts'o" <tytso@mit.edu>
Date: Tue, 06 Jan 2009 10:15:26 -0500

> The following commit, ad7a953c, "kbuild: strip generated symbols from
> *.ko" which was merged to the mainline last week (December 28th) has the
> unfortunate side effct of making ccache useless.  That's because all
> files are now built using a two step process.  First they are compiled
> to assembly via "gcc -S -o .tmp_foo.s" and then assembled via "gcc" in a
> separate step.  Unfortunately, ccache doesn't seem to be able to cache
> either the compilation or the assembly step (and it may not be worth it
> once the two steps are separated).

I think the problem might be that the assembler source always
"changes" because a different date or timestamp string is put in there
by gcc every time the assembler source is built.
