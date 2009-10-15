Return-Path: <linux-kernel-owner+w=401wt.eu-S935486AbZJOUZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935486AbZJOUZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 16:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935469AbZJOUZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 16:25:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:34895 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935439AbZJOUY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 16:24:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,568,1249282800"; 
   d="scan'208";a="457864949"
Subject: Re: [patch 2/2] x86_64: align RODATA kernel section to 2MB with
 CONFIG_DEBUG_RODATA
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Chinang" <chinang.ma@intel.com>
In-Reply-To: <20091015032429.GA10068@merkur.ravnborg.org>
References: <20091014214654.423040927@sbs-t61.sc.intel.com>
	 <20091014220254.190119924@sbs-t61.sc.intel.com>
	 <20091015032429.GA10068@merkur.ravnborg.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 15 Oct 2009 13:23:48 -0700
Message-Id: <1255638228.2532.4.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 20:24 -0700, Sam Ravnborg wrote:
> > +#else
> > +
> > +#define X64_ALIGN_DEBUG_RODATA_BEGIN
> > +#define X64_ALIGN_DEBUG_RODATA_END
> > +
> > +#endif
> 
> A coment describing the purpose of
> this would be nice.

I will update this in the next version of the patch.

> > @@ -726,9 +726,13 @@ void set_kernel_text_ro(void)
> >  
> >  void mark_rodata_ro(void)
> >  {
> > -	unsigned long start = PFN_ALIGN(_text), end = PFN_ALIGN(__end_rodata);
> > +	unsigned long start = PFN_ALIGN(_text);
> >  	unsigned long rodata_start =
> >  		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
> > +	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
> Here the symbol seems to be referenced unconditionally.

This function is defined only for CONFIG_DEBUG_RODATA.

thanks,
suresh

