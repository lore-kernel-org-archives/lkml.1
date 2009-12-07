Return-Path: <linux-kernel-owner+w=401wt.eu-S964967AbZLGSOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967AbZLGSOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964945AbZLGSOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:14:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964943AbZLGSOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:14:05 -0500
Date: Mon, 7 Dec 2009 13:13:01 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: GCC 4.x random code generator for x86_64 ?
Message-ID: <20091207181301.GQ22813@hs20-bc2-1.build.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <alpine.LFD.2.00.0912071707540.3089@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912071707540.3089@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 06:50:17PM +0100, Thomas Gleixner wrote:
> Can anyone shed some light on the following:
> 
> Applying a patch which adds a yet unused "extern int bla(void);" line
> to a header file results in something which is beyond me.
> 
> The .i files differ as expected in exaclty _one_ line.

The source code is different, so this doesn't seem to be random code
generation.  The extra declaration means following decls will have higher
uids and there is a bunch of places in gcc where hash tables are traversed
and code generation depends on the order in the traversal.  While hash
tables hashed on pointer values are considered important bugs because
generated code could change in between runs with the same source, traversal
of tables hashed by decl uids are far less severe - gcc makes no promises
that different sources result in the same generated code.
You are using quite oldish gcc, if you reproduce it with something newer
(current 4.5 trunk or recent gcc from redhat/gcc-4_4-branch) and provide
full preprocessed source and exact command line options, I'll have a look
though.

	Jakub
