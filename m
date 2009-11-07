Return-Path: <linux-kernel-owner+w=401wt.eu-S1751499AbZKGKUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbZKGKUH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 05:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZKGKUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 05:20:04 -0500
Received: from cantor.suse.de ([195.135.220.2]:58893 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZKGKUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 05:20:04 -0500
Date: Sat, 7 Nov 2009 11:20:07 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: castet.matthieu@free.fr, linux-kernel@vger.kernel.org
Subject: Re: Using x86 segments against NULL pointer deference exploit
In-Reply-To: <4AF4A924.5080609@zytor.com>
Message-ID: <alpine.LRH.2.00.0911071118350.31913@twin.jikos.cz>
References: <1257512389.4af41dc504e1b@imp.free.fr> <4AF4A924.5080609@zytor.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009, H. Peter Anvin wrote:

> Yes, it is.  On 32 bits it is possible to switch around segments and do 
> this (in which case you want it to only cover the actual kernel area, 
> and use USER_DS for all user-space references.)  This also lets you drop 
> nearly all pointer-range checks, since they are now redundant.  
> However, there is a cost -- it pretty much requires a segment register 
> for USER_DS (this used to be fs once upon a time, hence set_fs) and 
> probably would break Xen and possibly other virtualization solutions.

There are ways to work around this though (UDEREF implementation of this 
technique in PaX explicitly checks for VMWare signature and handles such 
case differently ... I guess the same could be done for other 
virtualization solutions).

Not that it would be particularly nice of course ... 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

