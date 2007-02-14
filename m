Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbXBNQp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbXBNQp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 11:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932392AbXBNQpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 11:45:53 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35046 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380AbXBNQps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 11:45:48 -0500
Date: Wed, 14 Feb 2007 08:45:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bill Lear <rael@zopyra.com>
cc: Junio C Hamano <junkio@cox.net>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.0
In-Reply-To: <17875.9043.217255.863200@lisa.zopyra.com>
Message-ID: <Pine.LNX.4.64.0702140839560.3604@woody.linux-foundation.org>
References: <7vlkj1v3av.fsf@assigned-by-dhcp.cox.net> <17875.9043.217255.863200@lisa.zopyra.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Feb 2007, Bill Lear wrote:
> 
> This is enabled by passing the --enable=receive-pack to the
> git-daemon (usually in the [x]?inetd configuration).
> 
> This has the benefit of:

Before you list the benefits, you should always talk about the lack of 
security! Let nobody enable it without realizing the dangers! Tell people 
to _only_ do this inside a company firewall, and even then, only if you 
trust everybody.

>   2) A less ugly URL to use: git://server/repo, instead of, say,
>      ssh+git://server/path/to/repos/repo.

Why do people use that silly "ssh+git://" format?

It's a cogito thing. Native git has never done it, and only supports it 
because cogito thought it must make sense.

The native git ssh URL is exactly the normal ssh URL:

	server:/path/to/repos/repo

and if you really want to use the "xxx://" format, you might as well just 
use

	ssh://server/path/to/repos/repo

which should also work fine. 

		Linus

PS. This is the commit message that  added "git+ssh://":

	Author: Linus Torvalds <torvalds@osdl.org>
	Date:   Fri Oct 14 17:14:56 2005 -0700
	
	    Support git+ssh:// and ssh+git:// URL
	
	    It seemed to be such a stupid syntax. It's both what "ssh://" means,
	    and it's what not specifying a protocol at _all_ means.
	
	    But hey, since we already have two ways of saying "use ssh with
	    pack-files", here's two more.

so it was deemed stupid from the get-go, and isn't even some "legacy" 
thing. It's purely a "cogito people thought it makes sense to point out 
that it's _both_ native git _and_ ssh protocol".
