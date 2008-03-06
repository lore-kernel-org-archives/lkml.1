Return-Path: <linux-kernel-owner+w=401wt.eu-S933242AbYCFUZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbYCFUZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbYCFUZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:25:00 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4011 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751023AbYCFUY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:24:59 -0500
Date: Thu, 6 Mar 2008 21:24:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Christoph Hellwig <hch@infradead.org>, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
Message-ID: <20080306202446.GA4225@ucw.cz>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080303230336.042604000@linux-os.sc.intel.com> <20080304012012.GB22431@infradead.org> <20080304014306.GC28006@linux-os.sc.intel.com> <20080304103220.GA17621@elte.hu> <20080304175528.GD28006@linux-os.sc.intel.com> <20080305194705.GA4386@ucw.cz> <20080306155141.GA23340@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306155141.GA23340@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-06 16:51:41, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > > kmem_cache_alloc() can fail (return NULL) and not handling it is a 
> > > > bug.
> > > 
> > > oops. you are correct. Will send a sigsegv in the failure case then. 
> > > Thanks.
> > 
> > You are introducing possibility of hard to debug error, where previous 
> > code just worked... Does not look like good idea to me.
> 
> hm, how does it differ from any other allocation failure? We could fail 

Well, we should not be sending SIGSEGV...? SIGBUS would be cleaner, or
SIGKILL... what happens when userland tries to catch this one?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
