Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbXLCSNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbXLCSNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 13:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXLCSNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 13:13:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37869
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbXLCSNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 13:13:45 -0500
Date: Mon, 03 Dec 2007 10:13:46 -0800 (PST)
Message-Id: <20071203.101346.261427003.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: romanol@upcomillas.es, lkml@rtr.ca, shemminger@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: namespace support requires network modules to say "GPL"
From: David Miller <davem@davemloft.net>
In-Reply-To: <m18x4b1wqt.fsf@ebiederm.dsl.xmission.com>
References: <475227B1.2060802@rtr.ca>
	<1196670255.4127.21.camel@rukbat>
	<m18x4b1wqt.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 03 Dec 2007 11:03:38 -0700

> Based on my experience with in-tree code and the few glimpses I
> have gotten of out of tree code the reason the out of tree code broke
> is because it is doing very questionable things.

Calling dev_get_by_foo() was never ever a very questionable thing.
Stop saying bullshit, because that's all that is coming out of your
mouth in this thread.

The fact is, these modules called perfectly fine interfaces and by
adding namespaces YOU BROKE THEM.

That by itself is OK, they can make the code changes to adapt and use
the init namespace.

Enforcing new licensing restrictions on them for existing interfaces
just because you add a new freaking argument that is practically
speaking a constant and always the same right now, on the other hand,
IS NOT FINE and you must fix this now.

I don't care how you do it.

If you don't want them to get at the init namespace symbol, fine,
revert all the dev_get_by_*() interfaces to not take the namespace
symbol and make them internally use the init namespace albeit
invisibly to the caller.

Then you make all the existing call sites invoke new dev_get_by_*_ns()
interfaces that take an explicit argument.  But only do this where it
is truly necessary, everything uses the init namespace practically
speaking and it's clearer if you conver to the *_ns() variant when the
code itself is converted.
