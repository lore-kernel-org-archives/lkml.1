Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbXL1D05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbXL1D05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 22:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbXL1D0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 22:26:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43584 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbXL1D0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 22:26:49 -0500
Date: Fri, 28 Dec 2007 03:26:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Lameter <clameter@sgi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: SLUB sysfs support
Message-ID: <20071228032645.GM27894@ZenIV.linux.org.uk>
References: <20071226221631.GD27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712262149000.19009@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712271222190.31582@schroedinger.engr.sgi.com> <20071227225947.GH27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712271508080.917@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712271552420.1154@schroedinger.engr.sgi.com> <20071227235804.GJ27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712271601200.1294@schroedinger.engr.sgi.com> <20071228004504.GK27894@ZenIV.linux.org.uk> <Pine.LNX.4.64.0712271811470.2053@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712271811470.2053@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2007 at 06:19:46PM -0800, Christoph Lameter wrote:
> nfsd4_delegations? What is this about?

The random lifetimes of user-visible files you create in sysfs.

> How do I scan for the symlinks in sysfs?

At which point are you going to do that?  AFAICS, the fundamental problem
is that you
	* have aliases indistinguishable, so kmem_cache_destroy() can't tell
which one is going away, no matter what
	* have per-alias objects in sysfs
As the result, you have a user-visible mess in that directory in sysfs.
And I don't see how you would deal with that - on the "the contents of
directory changes in so-and-so way when such-and-such operation is
done", not the implementation details one.

BTW, I'm rather sceptical about free use of slabs; keep in mind that their
names have to be unique with your sysfs layout, so...
