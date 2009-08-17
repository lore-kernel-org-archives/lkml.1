Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZHQDN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZHQDN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 23:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbZHQDN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 23:13:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:38852 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbZHQDNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 23:13:25 -0400
Date: Sun, 16 Aug 2009 20:16:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: James Morris <jmorris@namei.org>
Cc: Theodore Tso <tytso@mit.edu>, David Wagner <daw-news@cs.berkeley.edu>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Security: information leaks in /proc enable keystroke recovery
Message-ID: <20090816201606.6e96efc8@infradead.org>
In-Reply-To: <alpine.LRH.2.00.0908171237050.30748@tundra.namei.org>
References: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu>
	<20090816003326.GC7554@mit.edu>
	<h67kou$ahr$1@taverner.cs.berkeley.edu>
	<20090816013346.GA17958@mit.edu>
	<h6a8da$40j$1@taverner.cs.berkeley.edu>
	<20090817022215.GI17958@mit.edu>
	<alpine.LRH.2.00.0908171237050.30748@tundra.namei.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 12:45:45 +1000 (EST)
James Morris <jmorris@namei.org> wrote:

> On Sun, 16 Aug 2009, Theodore Tso wrote:
> 
> > On Mon, Aug 17, 2009 at 12:31:38AM +0000, David Wagner wrote:
> > > 
> > > OK.  What about this:
> > > 
> > > (a) Remove ESP and EIP from /proc/$pid/stat{,us} entirely.  Put
> > > them in some other file that is only readable by root and by the
> > > owner of the process, but is not world-readable.  We know that
> > > ESP and EIP can be used for keystroke recovery, and they are not
> > > usually used by administrators, so the first step is to lock them
> > > down tightly: there is no downside.
> > 
> > Agreed.
> 
> It might be best to require a capability for this if not root.
> 
> The candidates seem to be CAP_SYS_ADMIN and CAP_SYS_PTRACE.

I would suggest we just use the "can ptrace" permission function
altogether... (after all, if you can ptrace an app you already own all
its keys)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
