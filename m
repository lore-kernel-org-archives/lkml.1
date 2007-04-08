Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXDHUgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXDHUgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 16:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXDHUgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 16:36:51 -0400
Received: from mail.fieldses.org ([66.93.2.214]:52525 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXDHUgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 16:36:50 -0400
Date: Sun, 8 Apr 2007 16:36:47 -0400
To: Theodore Tso <tytso@mit.edu>, Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070408203647.GC10331@fieldses.org>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070407203633.GA21555@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 04:36:33PM -0400, Theodore Tso wrote:
> 1) Deprecate telldir/seekdir() altogether.  Relatively few progams use
> this functionality, and it is highly questionable how useful it is,
> anyway.  If you use telldir/seekdir and keep the cookie for a long
> time, even the POSIX-provided guarantees about files that are created
> and deleted between the telldir() and seekdir() points in time makes
> its utility highly dubious.

How will nfsd implement readdir?

> 2) If application programs must have telldir/seekdir, than expand the
> size of the cookie from 32-bits to a minimum of 128 bits, and
> preferably larger --- say 512 bits, to accomodate systems that might
> be using 512-bit variant of SHA-2.

NFS readdir cookies are currently 64 bits.

It'd be interesting to think about how to modify the protocol to make
this all easier, but any network filesystem protocol will need to give
clients some way to read through big directories one piece at a time.
Might also be nice if it worked even if the server rebooted partway
through....

--b.
