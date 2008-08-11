Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbYHKXOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbYHKXOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYHKXOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:14:36 -0400
Received: from vena.lwn.net ([206.168.112.25]:51903 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbYHKXOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:14:36 -0400
Date: Mon, 11 Aug 2008 17:14:33 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpoint/restart ABI
Message-ID: <20080811171433.2ce81f28@bike.lwn.net>
In-Reply-To: <200808112347.50245.arnd@arndb.de>
References: <20080807224033.FFB3A2C1@kernel>
	<200808111853.13854.arnd@arndb.de>
	<1218484114.5598.43.camel@nimitz>
	<200808112347.50245.arnd@arndb.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 23:47:49 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> The other problem that you really need to solve is interface
> stability. What you are creating is a binary representation
> of many kernel internal data structures, so in our common
> rules, you have to make sure that you remain forward and
> backward compatible. Simply saying that you need to run
> an identical kernel when restarting from a checkpoint is not
> enough IMHO.

OTOH, making one of these checkpoint files go into any 2.6.x kernel
seems like a very high bar, to the point, perhaps, of killing this
feature entirely.  

There could be a case for viewing sys_restore() as being a lot like
sys_init_module() - a view into kernel internals that goes beyond the
normal user-space ABI, and beyond the stability guarantee.  It might be
possible to create a certain amount of version portability with a
modversions-like mechanism, but it sure seems hard to do better than
that.

jon
