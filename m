Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbYHGNPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbYHGNPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYHGNOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:14:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49527 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753116AbYHGNOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:14:44 -0400
Date: Thu, 7 Aug 2008 11:30:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Morris <jmorris@namei.org>
Cc: David Wagner <daw@cs.berkeley.edu>, linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for
 on access scanning
Message-ID: <20080807113047.5cf7fe54@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LRH.1.10.0808070951550.15561@tundra.namei.org>
References: <20080805225524.GB4006@fieldses.org>
	<20080806101028.B87BA2FE88B@pmx1.sophos.com>
	<g7d8a1$81o$2@taverner.cs.berkeley.edu>
	<alpine.LRH.1.10.0808070951550.15561@tundra.namei.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In any case, the above relates to Windows desktops -- we are yet to see 
> a rationale for adding AV support to the Linux kernel.

s/we/you/

Clearly some people do see a rationale. At least some parts of it also
seem to make sense for picking up stuff in transit and for catching stuff
'in flight' between systems that might be more vulnerable.

It does appear possible to create a meaningful set of functionality for a
subset of the problem space - assuming no local compromise.

	- open for write causes some kind of state transition (even
SELinux label change)
	- last close notifies a userspace tool of some form (be it an
indexer or a scanner or whatever)
	- tool may or may not take some kind of action such as
relabelling.

At that point you can use selinux rules to say things like 'samba cannot
access content in 'change-in-progress' state.

Whether you allow opens to block for a scan really comes down to a risk
tradeoff. The "safe" approach is 'sorry someone has it open for writing
go away'. The lax approach is "yeah whatever, we may be unlucky if
something passes across our file server at the right moment" (allowing
anyone to read change-in-progress files) and somewhere in between is the
"wait a moment while I scan it" case, which reduces the time window of
attack considerably with a very high chance of detection if the attacker
gets it wrong).



Alan
