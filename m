Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZESNLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZESNLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZESNKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:10:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbZESNKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:10:55 -0400
Date: Tue, 19 May 2009 15:10:55 +0200
From: Jan Blunck <jblunck@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz,
       vaurora@redhat.com
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Message-ID: <20090519131055.GQ16526@bolzano.suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <200905191354.08701.arnd@arndb.de> <20090519121504.GO16526@bolzano.suse.de> <200905191421.21026.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905191421.21026.arnd@arndb.de>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, Arnd Bergmann wrote:

> 
> So what would go wrong if you only made them persistent for writable file
> systems, but allowed fallthrough dentries to be discarded for read-only
> file systems? As long as the lower layers don't change, you should still
> be able to reconstruct the same dentries every time you do a readdir, right?
> 

This can work if you do this when the last file descriptor on the directory is
closed. I have a similar patch around for tmpfs readdir (the SLES8 glibc is
seeking on readdir, so it broke some of our build servers that use tmpfs).

One idea would be to separate the "fallthru in tmpfs" handling into its own
library so that it can be shared by filesystems. This would become something
similar to the On-Disk-Format (ODF) approach that Erez Zadok followed with
UnionFS.
