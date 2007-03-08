Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbXCHLrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbXCHLrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 06:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXCHLrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 06:47:39 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39448 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751446AbXCHLri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 06:47:38 -0500
Date: Thu, 8 Mar 2007 12:47:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 16/20] swsusp: do not use virt_to_page on kernel data address
Message-ID: <20070308114712.GG5953@elf.ucw.cz>
References: <20070307065703.GA23412@in.ibm.com> <20070307072008.GQ23412@in.ibm.com> <20070307224915.GG5956@elf.ucw.cz> <20070308051730.GH6000@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308051730.GH6000@in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
> > 
> > > +static int swsusp_header_init(void)
> > > +{
> > > +	swsusp_header = (struct swsusp_header*) __get_free_page(GFP_KERNEL);
> > > +	if (!swsusp_header)
> > > +		panic("Could not allocate memory for swsusp_header\n");
> > > +	return 0;
> > > +}
> > > +
> > > +core_initcall(swsusp_header_init);
> > 
> > I do not like the panic, but I guess it is okay as we are running
> > during boot? (Could you add a comment?) Otherwise ok.
> > 
> 
> Hi Pavel,
> 
> Yes, it is an initcall and this memory page will be allocated during
> boot time. Not very sure what comment to put there. To me it seems
> pretty obivious with "core_initcall".

I'd put "/* running at boot time, so allocation can't fail */" there
(and maybe just replace panic with BUG_ON), but I guess that's not
important.

ACK.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
