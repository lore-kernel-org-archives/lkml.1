Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbZESMPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbZESMPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZESMPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:15:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbZESMPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:15:07 -0400
Date: Tue, 19 May 2009 14:15:04 +0200
From: Jan Blunck <jblunck@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz,
       vaurora@redhat.com
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Message-ID: <20090519121504.GO16526@bolzano.suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <E1M6Mez-0000tG-3q@pomaz-ex.szeredi.hu> <20090519103924.GL16526@bolzano.suse.de> <200905191354.08701.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905191354.08701.arnd@arndb.de>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, Arnd Bergmann wrote:

> On Tuesday 19 May 2009, Jan Blunck wrote:
> > > So this means that the topmost branch always needs to be writable,
> > > right?  It isn't possible to make a union of two iso9660 filesystems,
> > > for example?
> > 
> > Exactly. Although, you can do that with the help of tmpfs on top of the two
> > iso9660 filesystems.
> 
> But how do you get there? You can mount the tmpfs on top of two iso9660
> file systems, but it seems that you wouldn't be able to get the two
> stacked on top of each other in the first place.

Well, at the moment you can stack them but readdir will fail every time you
call it ... I think this is just a question of policy if we want to allow that
or not.

> Also, by mounting a tmpfs on top, wouldn't you you violate the requirement
> for persistent inode numbers again?

There is no requirement for persistent unique inode numbers except if you want
to export the union again. This is something that is out of scope of this
implementation. If you are going to export a union mounted filesystem, you
only export the topmost filesystem.

> > Or by adding fake write support to iso9660 ... 
> 
> This would work, but you'd have to do this for each file system if you want
> to be able to use it as the top of the union while backed by a read-only
> block device or when you don't want it to be written.

I know that the requirement for the topmost filesystem to be able to create
directories and fill them with fallthrus is an unattractive one. On the other
hand this is the cost that you have to pay at the moment to get this kind of
functionality. This implementation will not help with all use-cases. Its focus
is to get certain use-cases right.
