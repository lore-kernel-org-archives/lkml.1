Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYHKXX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYHKXX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYHKXXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:23:18 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49892 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYHKXXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:23:17 -0400
Subject: Re: checkpoint/restart ABI
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Arnd Bergmann <arnd@arndb.de>, "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080811171433.2ce81f28@bike.lwn.net>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808111853.13854.arnd@arndb.de> <1218484114.5598.43.camel@nimitz>
	 <200808112347.50245.arnd@arndb.de>  <20080811171433.2ce81f28@bike.lwn.net>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 16:23:14 -0700
Message-Id: <1218496994.5598.50.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-11 at 17:14 -0600, Jonathan Corbet wrote:
> On Mon, 11 Aug 2008 23:47:49 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > The other problem that you really need to solve is interface
> > stability. What you are creating is a binary representation
> > of many kernel internal data structures, so in our common
> > rules, you have to make sure that you remain forward and
> > backward compatible. Simply saying that you need to run
> > an identical kernel when restarting from a checkpoint is not
> > enough IMHO.
> 
> OTOH, making one of these checkpoint files go into any 2.6.x kernel
> seems like a very high bar, to the point, perhaps, of killing this
> feature entirely.  

The OpenVZ dudes like refer to something that Andrew Morton said about
this (paraphrasing...):  if we need cross-version restore support, we
can count on userspace to do the conversion.

You can almost think of it like the crashdump processing utility that we
have.  Instead of worrying about having the kernel *always* produce the
same crashdump with the same gunk in it, we make userspace do all the
parsing and interpretation.

It also makes it quite possible for a distribution to make a change (say
because of a security fix) in the kernel that changes the checkpoint
format, then to quickly code up the necessary bits for the conversion
program. 

-- Dave

