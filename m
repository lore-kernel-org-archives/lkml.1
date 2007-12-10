Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbXLJPsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbXLJPsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 10:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXLJPsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 10:48:15 -0500
Received: from mail.fieldses.org ([66.93.2.214]:53914 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447AbXLJPsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 10:48:13 -0500
Date: Mon, 10 Dec 2007 10:47:47 -0500
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, gnome42@gmail.com,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Denis V. Lunev" <den@openvz.org>, linux-nfs@vger.kernel.org
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Message-ID: <20071210154747.GB17209@fieldses.org>
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com> <200712101619.12522.maximlevitsky@gmail.com> <20071210143609.GF2138@fieldses.org> <200712101705.30428.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712101705.30428.maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 05:05:30PM +0200, Maxim Levitsky wrote:
> On Monday 10 December 2007 16:36:09 J. Bruce Fields wrote:
> > On Mon, Dec 10, 2007 at 04:19:12PM +0200, Maxim Levitsky wrote:
> > > ...
> > > > It is best not to use nohide - we should probably mark it as
> > > > 'legacy'.
> > > > 
> > > > Simply export the top level mountpoint as 'crossmnt'  and everything
> > > > below there will be exported.
> > > > 
> > > > > Where should I put those options in root file-system export or in submount export?
> > > > 
> > > > crossmnt goes at the top.  nohide goes in the submount.  Both have
> > > > the same general effect though with subtle differences.
> > > > You don't need both (though that doesn't hurt).
> > > > Just use crossmnt at the top,  Then you don't need to mention the
> > > > lower level filesystems at all.
> > > > 
> > > > > 
> > > ...
> > > > > (I decided to switch to NFS4 only due to the lack of ability to see underlying mounts)
> > > > > 
> > > > 
> > > > All of this should work fine with v3.  Once you have the right patch
> > > > for the crossmnt bug applied, if you have further problems post them
> > > > to linux-nfs@vger.kernel.org.
> > > > 
> > > > NeilBrown
> > > > 
> > > 
> > > Big thanks,
> > > 
> > > Still NFS server just don't want to accept the connection
> > > I noticed that if I first mount with
> > > -tnfs, unmount,  and then mount with -tnfs4, it works
> > 
> > OK, in that case, that's definitely the bug Eric sent out the patch for;
> > you may want to try applying his patch.
> You mean
> "[PATCH 2.6.24-rc4] proc: Remove/Fix proc generic d_revalidate" ?
> 
> I did apply it (on both kernel and server), and it doesn't help.
> Best regards,
> 	Maxim Levitsky
> 
> PS: I am unfamiliar with nfs/nfs4, so this could be just a 
> configuration/compilation issue.

What do
	ls /proc/fs/nfs
	ls /proc/fs/nfsd

report?

--b.
