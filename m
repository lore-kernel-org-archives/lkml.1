Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbYHGUb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbYHGUb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYHGUbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:31:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2190 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753681AbYHGUbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:31:44 -0400
Date: Thu, 7 Aug 2008 22:31:30 +0200
From: Pavel Machek <pavel@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 2/6] kexec jump: check code size in control page
Message-ID: <20080807203130.GA10331@ucw.cz>
References: <1218099926.5164.33.camel@caritas-dev.intel.com> <20080807131557.GB27783@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807131557.GB27783@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > PAGE_SIZE/2. This patch adds runtime checking for this.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
...

> >  {
> >  	if (nx_enabled)
> >  		set_pages_x(image->control_code_page, 1);
> > +
> > +	BUG_ON((unsigned long)kexec_control_page_code_end - \
> > +	       (unsigned long)relocate_kernel >= PAGE_SIZE/2);
> > +
> 

> Run time check is better than nothing but I think in this case it would
> be better if we can catch it at compile time. 
> 
> One of the methods will be to write a small program of your own and
> put in script/ and at build time check for the size and flag error. May
> be there are other better ways to do this.

BUILD_BUG_ON()?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
