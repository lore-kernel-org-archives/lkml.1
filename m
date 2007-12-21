Return-Path: <linux-kernel-owner+w=401wt.eu-S1761147AbXLUMu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761147AbXLUMu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbXLUMuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:50:21 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:62341 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbXLUMuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:50:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DE1vhwlf3/WCNziXMp0vY/9YUp4zwB9j7712hUb9Xm+cgeDAI0GA+5Vk5+vlJ6nANc9NmOgnDM4jCEO0GrLPj959Z0XEOjNdstDHH1wKHVT9HmsgiR0m9xkBixg3+/8so+ha1f6ad9Yzr5d1of48wMWfPAr0SFxQIv6+u1rqFPQ=
Message-ID: <851fc09e0712210450i1c39a37fxe716ffcd5de59850@mail.gmail.com>
Date: Fri, 21 Dec 2007 20:50:19 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH 2/3 -mm] kexec jump -v8 : add write support to oldmem device
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       "Kexec Mailing List" <kexec@lists.infradead.org>
In-Reply-To: <20071221101710.GB10573@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1198222420.1965.21.camel@caritas-dev.intel.com>
	 <20071221101710.GB10573@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 21, 2007 6:17 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> > This patch adds writing support for /dev/oldmem. This can be used to
> >
> > - Communicate between original kernel and kexeced kernel through write
> >   to some pages in original kernel.
> >
> > - Restore the memory contents of hibernated system in kexec based
> >   hibernation.
> >
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> >
> > --- a/arch/x86/kernel/crash_dump_32.c
> > +++ b/arch/x86/kernel/crash_dump_32.c
> > +ssize_t write_oldmem_page(unsigned long pfn, const char *buf,
> > +                       size_t csize, unsigned long offset, int
> > userbuf)
>
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -348,6 +348,37 @@ static ssize_t read_oldmem(struct file *
> >       }
> >       return read;
> >  }
> > +
> > +/*
> > + * Write memory corresponding to the old kernel.
> > + */
> > +static ssize_t write_oldmem(struct file *file, const char __user *buf,
> > +                         size_t count, loff_t *ppos)
> > +{
> ...
> > +             rc = write_oldmem_page(pfn, buf, csize, offset, 1);
>
> I believe this is going to break compilation on non-32bit
> machines.

Yes, I will fix this.

Best Regards,
Huang Ying
