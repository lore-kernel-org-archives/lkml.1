Return-Path: <linux-kernel-owner+w=401wt.eu-S1759334AbZASLA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbZASLA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 06:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758700AbZASLAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 06:00:12 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:41927 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697AbZASLAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 06:00:11 -0500
Date: Mon, 19 Jan 2009 12:01:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
Message-ID: <20090119110153.GA8321@uranus.ravnborg.org>
References: <1232287474.3130.19.camel@localhost.localdomain> <20090118185635.GA30514@elte.hu> <497445B6.7030606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497445B6.7030606@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> It does.  This patch will break userspace.
> 
> Doesn't 'make headers_install' unifder the CONFIG_ stuff?

Nope. headers_install only unifdef __KERNEL__ stuff.

> 
> >>@@ -384,18 +386,24 @@ struct kvm_trace_rec {
> >> #define KVM_CAP_MP_STATE 14
> >> #define KVM_CAP_COALESCED_MMIO 15
> >> #define KVM_CAP_SYNC_MMU 16  /* Changes to host mmap are reflected in 
> >> guest */
> >>+#ifdef __KERNEL__
> >> #if defined(CONFIG_X86)||defined(CONFIG_IA64)
> >> #define KVM_CAP_DEVICE_ASSIGNMENT 17
> >> #endif
> >>+#endif /* __KERNEL__ */
> >> #define KVM_CAP_IOMMU 18
> >>+#ifdef __KERNEL__
> >> #if defined(CONFIG_X86)
> >> #define KVM_CAP_DEVICE_MSI 20
> >> #endif
> >>+#endif /* __KERNEL__ */
> >> /* Bug in KVM_SET_USER_MEMORY_REGION fixed: */
> >> #define KVM_CAP_DESTROY_MEMORY_REGION_WORKS 21
> >>+#ifdef __KERNEL__
> >> #if defined(CONFIG_X86)
> >> #define KVM_CAP_USER_NMI 22
> >> #endif
> >>+#endif /* __KERNEL__ */
> >>    
> >
> >likewise, are these bits really used by user-space KVM bits? If not then 
> >the whole thing could go into an #ifdef __KERNEL__ block.
> >  
> 
> They are.  This bits advertise to userspace what features kvm supports, 
> both compile- and run-time.

This is wrong...
The headers does not change with the kernel configuration and advertising the
kvm features via a .h file like this is simply plain broken.
You cannot assume that the header files are generated with the exact same config
as used by the running kernel.
And userspace has in no way access to the CONFIG_ namespace which is purely kernel-internal.

I cannot see how you have ever seen kcm advertise that for example KVM_CAP_USER_NMI
equals to 22 because CONFIG_X86 is never (supposed to be) defined in userspace -
except if you did so yourself by some means.

	Sam
