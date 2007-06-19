Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbXFSWWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbXFSWWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759665AbXFSWVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:21:49 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:38512 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758411AbXFSWVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:21:47 -0400
Date: Tue, 19 Jun 2007 18:21:46 -0400
To: david@lang.hm
Cc: Chris Snook <csnook@redhat.com>, Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, hpa@zytor.com,
       alan <alan@clueserver.org>
Subject: Re: Versioning file system
Message-ID: <20070619222146.GS10008@csclub.uwaterloo.ca>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com> <20070619204317.GR10008@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706191505130.26701@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706191505130.26701@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 03:07:40PM -0700, david@lang.hm wrote:
> since anything starting with . is considered a 'hidden' file per *nix 
> tradition it's ignored by many programs and optionally ignored by most 
> others (and anything that doesn't ignore . files when presending files to 
> the user has many other problems on modern desktop systems anyway ;-)
> 
> the only trouble I ever had with the .snapshot approach is when tar or 
> find would decend down into the .snapshot when I didn't really intend for 
> it to do so.

That is why a readdir shouldn't even include .snapshot.  Only explicitly
asking to open .snapshot should give it to you.  That way tar can't
accidentally include it unless you specifically asked it to go into
.snapshot and archive the contents.

So by hidden it means completely hidden, not just left out by the shell
and the unix conventions.

Of course backup tools have to know about this, but then again backup
tools have to know about all sorts of low level filesystem stuff that
normal tools don't.

--
Len Sorensen
