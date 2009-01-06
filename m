Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZAFSjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZAFSjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZAFSjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:39:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34917
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbZAFSjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:39:43 -0500
Date: Tue, 06 Jan 2009 10:39:44 -0800 (PST)
Message-Id: <20090106.103944.99651976.davem@davemloft.net>
To: sam@ravnborg.org
Cc: viro@ZenIV.linux.org.uk, jbeulich@novell.com, mingo@elte.hu,
       rostedt@goodmis.org, srostedt@redhat.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: ftrace breaks sparc64 build
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090106133442.GA14780@uranus.ravnborg.org>
References: <49631BF0.76E4.0078.0@novell.com>
	<20090106113543.GS28946@ZenIV.linux.org.uk>
	<20090106133442.GA14780@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 6 Jan 2009 14:34:42 +0100

> But I never managed to really understand what the btfixup thing is all
> about and has then been sidetracked by funnier stuff.

It's recording relocations that get fixed up at boot time.

The way it works is that each btfixup emits a reference to a symbol
that will be unresolved.

The btfixup tool under arch/sparc/boot/ scans the unlinked kernel
image, generates dummy symbol definitions into a foo.s file so that
the kernel can be linked, and builds the btfixup tables so the kernel
can patch up these relocations at boot time.
