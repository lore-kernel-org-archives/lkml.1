Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbXEXSkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbXEXSkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXEXSkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:40:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34093 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbXEXSkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:40:42 -0400
Date: Thu, 24 May 2007 19:40:39 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: James Morris <jmorris@namei.org>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Message-ID: <20070524184039.GH4095@ftp.linux.org.uk>
References: <20070412090809.917795000@suse.de> <200705241112.41101.agruen@suse.de> <Line.LNX.4.64.0705240858190.6121@d.namei> <200705242010.00961.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705242010.00961.agruen@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 08:10:00PM +0200, Andreas Gruenbacher wrote:

> Read it like this: we don't have a good idea how to support multiple 
> namespaces so far. Currently, we interpret all pathnames relative to the 
> namespace a process is in. Confined processes don't have the privilege to 
> create or manipulate namespaces, which makes this safe. We may find a better 
> future solution.

You also don't have a solution for multiple chroot jails, since they
often have the same fs mounted in many places on given box *and* since
the pathnames from the confined processes' POVs have fsck-all to do
with each other.

It's really not kinder than multiple namespaces as far as your approach
is concerned.
