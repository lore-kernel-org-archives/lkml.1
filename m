Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbXFVJ7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbXFVJ7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 05:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbXFVJ7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 05:59:45 -0400
Received: from mail.suse.de ([195.135.220.2]:48541 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbXFVJ7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 05:59:43 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Date: Fri, 22 Jun 2007 11:59:13 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, Greg KH <greg@kroah.com>,
       Crispin Cowan <crispin@novell.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <Pine.LNX.4.64.0706151656170.12349@asgard.lang.hm> <20070616002012.GH2616@elf.ucw.cz>
In-Reply-To: <20070616002012.GH2616@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706221159.13948.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 June 2007 02:20, Pavel Machek wrote:
> Ok, so mv gets slower for big trees... and open() gets faster for deep
> trees. Previously, open in current directory was one atomic read of
> directory entry, now it has to read directory, and its parent, and its
> parent parent, and its...
>
> (Or am I wrong and getting full path does not need to bring anything
> in, not even in cache-cold case?)

You are wrong, indeed. The dentries in the dcache are connected to the dcache 
through their parent dentry pointers, which means that the parent dentries 
are always in memory, too. No I/O is involved for walking up dentry trees.

(Caveat: nfsd does allow disconnected dentries. It does not make sense to try 
confining an in-kernel daemon though, an no user process can ever access a 
dentry before it gets connected (lookup does that), so this difference is 
irrelevant here.)
