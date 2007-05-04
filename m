Return-Path: <linux-kernel-owner+w=401wt.eu-S1030943AbXEDP5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030943AbXEDP5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030945AbXEDP5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:57:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030943AbXEDP5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:57:18 -0400
Date: Fri, 4 May 2007 11:57:11 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Steve French (smfltc)" <smfltc@us.ibm.com>
Cc: linux-cifs-client@lists.samba.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Layton <jlayton@redhat.com>, hch@infradead.org
Subject: Re: [PATCH] CIFS: make sec=none force an anonymous mount
Message-ID: <20070504155710.GB18522@dantu.rdu.redhat.com>
References: <20070504024910.CE97B1638AF@lists.samba.org> <463B50A5.3070500@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463B50A5.3070500@us.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 10:26:29AM -0500, Steve French (smfltc) wrote:
> Jeff Layton wrote:
> >We had a customer report that attempting to make CIFS mount with a null
> >username (i.e. doing an anonymous mount) doesn't work. Looking through the
> >code, it looks like CIFS expects a NULL username from userspace in order
> >to trigger an anonymous mount. The mount.cifs code doesn't seem to ever
> >pass a null username to the kernel, however.
> Yes - cifs kernel code expects a NULL username (e.g. "username=") if 
> you really don't want to pass the default username of the uid of 
> the current process and you don't set the username explicitly
> (e.g. in a credential file or mount parameter).
> 
> Samba userspace tools (and smbfs) handled this by first trying to
> setup the SMB session using the default user, and if that fails 
> with access denied then retrying sessionsetup with a null username 
> string.  This would be easy to change in mount.cifs (ie as long 
> as username was not explicitly passed on mount then if mount fails
> with access denied simply add a retry with "username=").  This was
> discussed at SambaXP.
> 

Does this mean you're NAK'ing this patch in favor of a userspace fix? My
perspective is that if someone explicitly requests sec=none, then we ought
to do an anonymous mount regardless of how the username is set. Would
you agree that that behavior is what you would want?

> 
> Christoph Hellwig wrote:
> >Looks useful.  In case you have some spare time at your hand it would
> >be really nice to convert cifs option parsing to the lib/parser.c code
> >and move all validation of the arguments into one place, so it's easily
> >understanable and better to maintain.
> 
> Yes - that would be excellent.  The parse_mount_options badly needs to
> be rewritten now that the number of mount options needed has grown.   
> This is something Alex Bokovoy and I discussed last week at SambaXP 
> for both the kernel code and the user space mount.cifs code.
> Alex had volunteered to rewrite the user space cifs mount option
> parsing code (and also change to use the safer talloc library)
> 

Definitely, though that sounds like a big project and I don't have the time to
tackle it at the moment :-)

Thanks,
Jeff

