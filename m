Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbZDQRF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbZDQRF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbZDQRFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:05:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbZDQRFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:05:12 -0400
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
 syscalls with a mutex
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090417165643.GL8253@elte.hu>
References: <1239892078-6039-1-git-send-email-abogani@texware.it>
	 <20090416160645.GB17804@elte.hu>
	 <20090416235649.GF26366@ZenIV.linux.org.uk>
	 <20090417000142.GF21405@elte.hu>
	 <20090417001345.GH26366@ZenIV.linux.org.uk>
	 <20090417002744.GB29630@elte.hu>
	 <20090417003805.GI26366@ZenIV.linux.org.uk> <20090417165643.GL8253@elte.hu>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 19:04:45 +0200
Message-Id: <1239987885.23397.4817.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 18:56 +0200, Ingo Molnar wrote:

> Stupid question regarding c): wouldnt such data structures go via 
> the VFS - which you said was free of BKL constraints? Or are there 
> interconnected private data structures between certain types of 
> closely related filesystems that the VFS does not know about? (and 
> hence might have BKL assumptions)

The VFS is stuffed with ->private like pointers for filesystems to flesh
out, and I could well imagine some implicit serialization between the
various (4?) VFS hooks that are currently still under BKL.

Anyway, it seems quite clear that the first thing is to push the current
BKL usage down into the filesystems -- which should be somewhat
straight-forward.

After that it really comes down to picking off these filesystems one at
a time, which will really need a proper audit, there just ain't a proper
substitute for thinking ;-)

