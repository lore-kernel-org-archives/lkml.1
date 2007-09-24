Return-Path: <linux-kernel-owner+w=401wt.eu-S1760526AbXIXWG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526AbXIXWG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbXIXWGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:06:48 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42997 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbXIXWGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:06:47 -0400
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <20070923231713.f81ee0db.akpm@linux-foundation.org>
References: <20070920195249.852667D5@kernel>
	 <20070920195320.38C8E20D@kernel>
	 <20070923231713.f81ee0db.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 15:06:42 -0700
Message-Id: <1190671602.26982.261.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-23 at 23:17 -0700, Andrew Morton wrote:
> It look like a false positive to me, but really, for a patchset of this
> complexity and maturity I cannot fathom how it could have escaped any
> lockdep testing.

I test with lockdep all the time.  The problem was that lockdep doesn't
complain until you have 8 nested locks, and I only tested on a 4-cpu
system.

I lowered the lockdep nesting limit to 3, and got the warning on my
machine.

-- Dave

