Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbZHQCpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbZHQCpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 22:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbZHQCpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 22:45:49 -0400
Received: from tundra.namei.org ([65.99.196.166]:49222 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbZHQCpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 22:45:49 -0400
Date: Mon, 17 Aug 2009 12:45:45 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Theodore Tso <tytso@mit.edu>
cc: David Wagner <daw-news@cs.berkeley.edu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: Security: information leaks in /proc enable keystroke recovery
In-Reply-To: <20090817022215.GI17958@mit.edu>
Message-ID: <alpine.LRH.2.00.0908171237050.30748@tundra.namei.org>
References: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu> <20090816003326.GC7554@mit.edu> <h67kou$ahr$1@taverner.cs.berkeley.edu> <20090816013346.GA17958@mit.edu> <h6a8da$40j$1@taverner.cs.berkeley.edu> <20090817022215.GI17958@mit.edu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Aug 2009, Theodore Tso wrote:

> On Mon, Aug 17, 2009 at 12:31:38AM +0000, David Wagner wrote:
> > 
> > OK.  What about this:
> > 
> > (a) Remove ESP and EIP from /proc/$pid/stat{,us} entirely.  Put them in
> > some other file that is only readable by root and by the owner of the
> > process, but is not world-readable.  We know that ESP and EIP can be used
> > for keystroke recovery, and they are not usually used by administrators,
> > so the first step is to lock them down tightly: there is no downside.
> 
> Agreed.

It might be best to require a capability for this if not root.

The candidates seem to be CAP_SYS_ADMIN and CAP_SYS_PTRACE.

> Maybe we should only be recording the last access and last modified
> time on pseudo-tty's to a second granularity, hmmm?

I can't think of a valid case for finer granularity here, although I guess 
it could be made a sysctl if necessary.

I wonder if there are any other channels?


- James
-- 
James Morris
<jmorris@namei.org>
