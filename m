Return-Path: <linux-kernel-owner+w=401wt.eu-S932683AbXK2Rqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbXK2Rqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759877AbXK2Rqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:46:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43965 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759951AbXK2Rqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:46:30 -0500
Date: Thu, 29 Nov 2007 09:45:28 -0800
From: Greg KH <greg@kroah.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Jon Masters <jonathan@jonmasters.org>, Valdis.Kletnieks@vt.edu,
       Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071129174528.GA14431@kroah.com>
References: <25290.1196273705@turing-police.cc.vt.edu> <20071128183040.GW8181@ftp.linux.org.uk> <20071129003840.GA22530@kroah.com> <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr> <20071129010753.GA19106@kroah.com> <1196354172.6473.52.camel@perihelion> <20071129164746.GB9664@kroah.com> <Pine.LNX.4.64.0711291752550.13075@fbirervta.pbzchgretzou.qr> <20071129170326.GA10024@kroah.com> <2c0942db0711290935l56d28b70v2b35dfb1663e4d2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0711290935l56d28b70v2b35dfb1663e4d2b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 09:35:56AM -0800, Ray Lee wrote:
> On Nov 29, 2007 9:03 AM, Greg KH <greg@kroah.com> wrote:
> > On Thu, Nov 29, 2007 at 05:53:33PM +0100, Jan Engelhardt wrote:
> > >
> > > On Nov 29 2007 08:47, Greg KH wrote:
> > > >On Thu, Nov 29, 2007 at 11:36:12AM -0500, Jon Masters wrote:
> > > >> On Wed, 2007-11-28 at 17:07 -0800, Greg KH wrote:
> > > >>
> > > >> > The easiest way is as Al described above, just have the userspace
> > > >> > program that wrote the file to disk, check it then.
> > > >>
> > > >> But the problem is that this isn't just Samba, this is a countless
> > > >> myriad of different applications. And if one of them doesn't support
> > > >> on-access scanning, then the whole solution isn't worth using.
> > > >
> > > >Ok, which specific applications do they care about?  Last time I asked
> > > >it was still limited to a very small handful, all of which would be
> > > >trivial to add such a hook to.
> > > >
> > > Well, think bash, syscalls. While you can add a plugin to samba "easily",
> > > it seems overkill to do the same for rm, mv, cp, bash.
> >
> > Again, these are not things that these companies care about.
> 
> Perhaps if you looked at this outside of a file-server scenario, the
> problem would be clearer? Anti-malware companies want to check
> anything written to disk on a system, either at write time or blocking
> the open/mmap. That means proactively protecting email programs with
> known vulnerabilities that have yet to be patched, web browsers
> writing and reading their caches, an Apache instance running WebDAV,
> the list goes on. And these are on desktop systems, with no attached
> file/network server.

Ok, if they want to check on every open/mmap then just hook in glibc to
do this.  Especially as they want to run userspace code at this point in
time.

Again, let's wait for some code to show up before discussing this
further.

thanks,

greg k-h
