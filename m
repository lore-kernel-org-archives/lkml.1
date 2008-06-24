Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbYFXMgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbYFXMgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 08:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYFXMgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 08:36:44 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:57587 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYFXMgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:36:43 -0400
Date: Tue, 24 Jun 2008 16:36:45 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: link failure fix
Message-ID: <20080624123645.GA5237@jurassic.park.msu.ru>
References: <20080620232621.GB8061@jurassic.park.msu.ru> <20080621201742.GA2061@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621201742.GA2061@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 10:17:42PM +0200, Sam Ravnborg wrote:
> Most other architectures would only notice when the exit function
> is called because they do late discardning og the exit section.
> alpha (and sparc) are some of the few architectures that discard exit
> section at link time thus you will see this much sooner
> than the others.

Ah, indeed. Then it's not so critical on x86 and others.

> Are the any size penalties here?

Just checked: quite the contrary, on alpha with -fno-jump-tables
resulting kernel image is a few kilobytes smaller (~17Kb in my config,
vmlinux is ~5Mb).

> I assume there are a minimal performance penalty.

Yeah, I don't think there are lots of big switch statements in the
hot paths.

Ivan.
