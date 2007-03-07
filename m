Return-Path: <linux-kernel-owner+w=401wt.eu-S932744AbXCGQjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbXCGQjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932774AbXCGQjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:39:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42817 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744AbXCGQjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:39:23 -0500
Date: Wed, 7 Mar 2007 08:38:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Verych <olecom@flower.upol.cz>
cc: David Howells <dhowells@redhat.com>, Al Viro <viro@ftp.linux.org.uk>,
       akpm@linux-foundation.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, johannes@sipsolutions.net
Subject: Re: ALIGN via ilog2 without gccisms (Re: [PATCH] Fix get_order())
In-Reply-To: <E1HOybN-00031m-6M@flower>
Message-ID: <Pine.LNX.4.64.0703070836220.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703061913080.5963@woody.linux-foundation.org>
 <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com>
 <8543.1173267786@redhat.com> <E1HOybN-00031m-6M@flower>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Oleg Verych wrote:
>
> Probably it can be used to get rid of gccisms and "type fluff" due to
> bitwise arithmetics in ALIGN?

Hell no.

The typeof is there to make sure we have the right type, and it's simple.

The current ALIGN() macro is efficient as hell (generating just a simple 
mask+add). Turning it into some kind of horrible thing that uses ilog2() 
would be a total mistake.

Also, your ALIGN() macro was broken. That's not how ALIGN() is supposed to 
work.

		Linus
