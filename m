Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYHMRIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYHMRIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbYHMRIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:08:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbYHMRIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:08:21 -0400
Date: Wed, 13 Aug 2008 10:07:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec jump: fix code size checking
Message-Id: <20080813100703.10f50b40.akpm@linux-foundation.org>
In-Reply-To: <20080813131927.GB3957@redhat.com>
References: <1218589475.24951.59.camel@caritas-dev.intel.com>
	<20080813131927.GB3957@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 09:19:27 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Aug 13, 2008 at 09:04:35AM +0800, Huang Ying wrote:
> > Fix building issue when CONFIG_KEXEC=n. Thanks to Vivek Goyal for his
> > reminding.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > 
> > ---
> >  include/asm-x86/kexec.h |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > --- a/include/asm-x86/kexec.h
> > +++ b/include/asm-x86/kexec.h
> > @@ -43,6 +43,9 @@
> >  
> >  #ifdef CONFIG_X86_32
> >  # define KEXEC_CONTROL_CODE_MAX_SIZE	2048
> > +# ifndef CONFIG_KEXEC
> > +#  define kexec_control_code_size	0
> > +# endif
> >  #endif
> >  
> >  #ifndef __ASSEMBLY__
> 
> I think Andrew already fixed it. Right way is to put code in vmlinux.lds.S
> under #ifdef CONFIG_KEXEC, than defining the symbol kexec_control_code_size
> if CONFIG_KEXEC=n

I was wondering about that.

I resurrected that patch.
