Return-Path: <linux-kernel-owner+w=401wt.eu-S1762190AbXK2BDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190AbXK2BDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760183AbXK2BD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:03:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55515 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760074AbXK2BD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:03:28 -0500
Date: Wed, 28 Nov 2007 17:07:53 -0800
From: Greg KH <greg@kroah.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Valdis.Kletnieks@vt.edu, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071129010753.GA19106@kroah.com>
References: <20071128144156.GA14106@infradead.org> <416908.77038.qm@web36613.mail.mud.yahoo.com> <20071128164613.GA21815@infradead.org> <25290.1196273705@turing-police.cc.vt.edu> <20071128183040.GW8181@ftp.linux.org.uk> <20071129003840.GA22530@kroah.com> <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 01:53:46AM +0100, Jan Engelhardt wrote:
> 
> On Nov 28 2007 16:38, Greg KH wrote:
> >> 
> >> And if we are talking about the situation when files are written to
> >> in controlled way (i.e. we are not concerned with malware running on
> >> the box in question and just want to stop it from passing through
> >> mailsewer, etc.), then there's no damn need to play with LSM - just
> >> have e.g. coda with its commit-on-close and run the scanner on
> >> commit.  End of story.  Mind you, in such setups one would be much
> >> better off just having the mail server run the tests explicitly in
> >> the userland, along with the rest of anti-spam, etc. filters.
> >
> >I've repeated the above statements so many times to a number of the
> >anti-virus companies, and other people that really should know better,
> >that I'm really sick of it.  For some reason, they keep trying to do
> >things like this in the kernel, despite it being trivial to do in
> >userspace properly.
> >
> Do you mean something along the lines of FUSE?

That is one way, but not the simplest or nicest (people don't want to
run their whole fs on FUSE just yet).

The easiest way is as Al described above, just have the userspace
program that wrote the file to disk, check it then.

There are some nice SAMBA plugins that do just that already out there...

thanks,

greg k-h
