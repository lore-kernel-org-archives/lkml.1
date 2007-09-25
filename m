Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbXIYFIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbXIYFIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 01:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbXIYFIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 01:08:01 -0400
Received: from ozlabs.org ([203.10.76.45]:44643 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbXIYFIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 01:08:01 -0400
Subject: lib-y vs EXPORT_SYMBOL: who wins?
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 15:07:44 +1000
Message-Id: <1190696865.27805.317.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Various files under lib/ are linked into a .a so they only get linked if
needed.  But many of these functions are also EXPORT_SYMBOL()ed.

This doesn't really make sense: if it's exported it really needs to be
present.  Certain configurations can hit this (lguest uses kasprintf,
and can be a module).

We could do something hacky and try to figure out if any modules need
the symbols, which screws modules built later, but is no worse than a
CONFIG_-based solution.

Or to we just move all the exported functions out of the .a?

Cheers,
Rusty.

