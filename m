Return-Path: <linux-kernel-owner+w=401wt.eu-S1762043AbZEMXPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762043AbZEMXPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbZEMXPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 19:15:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbZEMXPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 19:15:23 -0400
Date: Wed, 13 May 2009 16:10:25 -0700
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       David Howells <dhowells@redhat.com>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090513231025.GB12187@suse.de>
References: <ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com> <1242142528.31807.80.camel@localhost.localdomain> <ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com> <1242168913.6711.9.camel@poy> <10761.1242220810@redhat.com> <ac3eb2510905130634l75ef8f78v604c53fb4bc3167f@mail.gmail.com> <ac3eb2510905130720x38de25adxc83b10aea0b86ce1@mail.gmail.com> <1242225358.9974.26.camel@localhost.localdomain> <1242233101.2893.7.camel@poy> <m1d4ac39pr.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4ac39pr.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 03:43:28PM -0700, Eric W. Biederman wrote:
> Kay Sievers <kay.sievers@vrfy.org> writes:
> 
> > On Wed, 2009-05-13 at 10:35 -0400, Stephen Smalley wrote:
> >> > Maybe we could do the same credential swap in sysfs, and get rid of:
> >> > /**
> >> >  * lookup_one_noperm - bad hack for sysfs
> >> > 
> >> > Seems a bit odd to have a vfs function for a single filesystem, called
> >> > from a single location, and annotated as "do not use". Christoph added
> >> > the comment a while ago, so adding him to Cc:.
> >> 
> >> Yes, that makes sense to me as well - we didn't have the credentials
> >> infrastructure in place at the time that lookup_one_noperm was
> >> introduced, but switching the credentials around a normal lookup_one_len
> >> call should work now.
> >
> > Something like this? It seems to work fine here, but I did not test it with SELinux.
> 
> That just masks the problem not fixes it.
> 
> The problem is that sysfs attempts to keep the dcache in lock-step with
> the sysfs_dentries.
> 
> The VFS model is lazy coherency and bringing things in sync on access.
> This is important to avoid locking problems.

So how would you propose to resolve this?

thanks,

greg k-h
