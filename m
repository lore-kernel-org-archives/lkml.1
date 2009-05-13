Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbZEMOn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbZEMOn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZEMOnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:43:46 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:35893 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZEMOnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:43:45 -0400
Subject: Re: [patch 00/13] devtmpfs patches
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Howells <dhowells@redhat.com>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <ac3eb2510905130720x38de25adxc83b10aea0b86ce1@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	 <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil>
	 <ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com>
	 <1242132344.31807.48.camel@localhost.localdomain>
	 <ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com>
	 <1242142528.31807.80.camel@localhost.localdomain>
	 <ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com>
	 <1242168913.6711.9.camel@poy> <10761.1242220810@redhat.com>
	 <ac3eb2510905130634l75ef8f78v604c53fb4bc3167f@mail.gmail.com>
	 <ac3eb2510905130720x38de25adxc83b10aea0b86ce1@mail.gmail.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 13 May 2009 10:35:58 -0400
Message-Id: <1242225358.9974.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 16:20 +0200, Kay Sievers wrote:
> On Wed, May 13, 2009 at 15:34, Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> >>> +     kern_cred = prepare_kernel_cred(NULL);
> >>
> >> If you have no intention of altering the credentials you create, you might
> >> want to use &init_cred instead of kern_cred.  That said, you might want to
> >> allocate it and let the security module alter it before you use it.
> >
> > Ah, didn't know that it was exported. It's the one in
> > include/linux/init_task.h, right? I'll give that a try.
> 
> That seems to work fine here. Thanks a lot for the help.
> 
> Maybe we could do the same credential swap in sysfs, and get rid of:
> /**
>  * lookup_one_noperm - bad hack for sysfs
>  * @name:       pathname component to lookup
>  * @base:       base directory to lookup from
>  *
>  * This is a variant of lookup_one_len that doesn't perform any permission
>  * checks.   It's a horrible hack to work around the braindead sysfs
>  * architecture and should not be used anywhere else.
>  *
>  * DON'T USE THIS FUNCTION EVER, thanks.
>  */
> 
> in fs/namei.c?
> 
> Seems a bit odd to have a vfs function for a single filesystem, called
> from a single location, and annotated as "do not use". Christoph added
> the comment a while ago, so adding him to Cc:.

Yes, that makes sense to me as well - we didn't have the credentials
infrastructure in place at the time that lookup_one_noperm was
introduced, but switching the credentials around a normal lookup_one_len
call should work now.

-- 
Stephen Smalley
National Security Agency

