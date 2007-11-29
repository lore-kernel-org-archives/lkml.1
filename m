Return-Path: <linux-kernel-owner+w=401wt.eu-S1762635AbXK2RgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762635AbXK2RgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760212AbXK2RgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:36:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:54961 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759057AbXK2RgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:36:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XGIlFp7/26g8JMXfkWt34qx33Gwf36WZpmb6rWG52GUOTvw1bGMzd40qOUkF9zPKeGWK6sMZXkT0W4nxDzvRr35ezd9RwAeHTxxzJyU3FYfWQ6nQT1n2rkfvvTNoBHmy6Sj/TvH0FtTkOmi5IdumtFrpdLdW6L5JUUuCS1VyNYQ=
Message-ID: <2c0942db0711290935l56d28b70v2b35dfb1663e4d2b@mail.gmail.com>
Date: Thu, 29 Nov 2007 09:35:56 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Out of tree module using LSM
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Jon Masters" <jonathan@jonmasters.org>, Valdis.Kletnieks@vt.edu,
       "Christoph Hellwig" <hch@infradead.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071129170326.GA10024@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <416908.77038.qm@web36613.mail.mud.yahoo.com>
	 <25290.1196273705@turing-police.cc.vt.edu>
	 <20071128183040.GW8181@ftp.linux.org.uk>
	 <20071129003840.GA22530@kroah.com>
	 <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr>
	 <20071129010753.GA19106@kroah.com>
	 <1196354172.6473.52.camel@perihelion>
	 <20071129164746.GB9664@kroah.com>
	 <Pine.LNX.4.64.0711291752550.13075@fbirervta.pbzchgretzou.qr>
	 <20071129170326.GA10024@kroah.com>
X-Google-Sender-Auth: 9790632e526eb5a6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 9:03 AM, Greg KH <greg@kroah.com> wrote:
> On Thu, Nov 29, 2007 at 05:53:33PM +0100, Jan Engelhardt wrote:
> >
> > On Nov 29 2007 08:47, Greg KH wrote:
> > >On Thu, Nov 29, 2007 at 11:36:12AM -0500, Jon Masters wrote:
> > >> On Wed, 2007-11-28 at 17:07 -0800, Greg KH wrote:
> > >>
> > >> > The easiest way is as Al described above, just have the userspace
> > >> > program that wrote the file to disk, check it then.
> > >>
> > >> But the problem is that this isn't just Samba, this is a countless
> > >> myriad of different applications. And if one of them doesn't support
> > >> on-access scanning, then the whole solution isn't worth using.
> > >
> > >Ok, which specific applications do they care about?  Last time I asked
> > >it was still limited to a very small handful, all of which would be
> > >trivial to add such a hook to.
> > >
> > Well, think bash, syscalls. While you can add a plugin to samba "easily",
> > it seems overkill to do the same for rm, mv, cp, bash.
>
> Again, these are not things that these companies care about.

Perhaps if you looked at this outside of a file-server scenario, the
problem would be clearer? Anti-malware companies want to check
anything written to disk on a system, either at write time or blocking
the open/mmap. That means proactively protecting email programs with
known vulnerabilities that have yet to be patched, web browsers
writing and reading their caches, an Apache instance running WebDAV,
the list goes on. And these are on desktop systems, with no attached
file/network server.

Yes, each and every one of these programs could have a malware
scanning engine slapped inside of them. But that proves what? That's
like saying each an every program on a system should have the SELinux
policies built into them, and yet we have that in-kernel instead.
