Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYAQDWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYAQDWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYAQDWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:22:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:58485 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYAQDWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:22:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nV+nAy4ptJotJIv6/y59enLdAnomn6AZVtF7KgEmk8lWkMvuF8s0rz+QshSCB7fEG+ez87aGTLXVNYA/TJvrWOzmX/WGqDQojpijkMXucZQMLnQLOT1lVOWkmuJewkxVvBEu2+n0MBv7WZe9j4NEfoRkWV09lldcCjMu3xXtheU=
Subject: Re: [PATCH] [3/7] Use shorter addresses in i386 segfault printks
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <478EC77E.8090103@zytor.com>
References: <200801161127.268350000@suse.de>
	 <20080116222706.8074A14EE3@wotan.suse.de> <1200538738.17967.4.camel@brick>
	 <478EC77E.8090103@zytor.com>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 19:22:21 -0800
Message-Id: <1200540141.17967.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-16 at 22:11 -0500, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> > On Wed, 2008-01-16 at 23:27 +0100, Andi Kleen wrote:
> >> Signed-off-by: Andi Kleen <ak@suse.de>
> >>
> >> ---
> >>  arch/x86/mm/fault_32.c |    2 +-
> > 
> > Could use exactly the same in fault_64.c
> > 
> >>  #ifdef CONFIG_X86_32
> >> -			"%s%s[%d]: segfault at %08lx ip %08lx sp %08lx error %lx\n",
> >> +			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx\n",
> >>  #else
> >>  			"%s%s[%d]: segfault at %lx ip %lx sp %lx error %lx\n",
> >>  #endif
> > 
> > With the ongoing unification work, it would be nice if we could come
> > up with a way to unify printks like this.  Anyone have any bright ideas
> > on a format that will keep the current alignment on 32 and 64 bit with
> > the same syntax, or will these tiny ifdefs keep sprouting?
> > 
> 
> Casting to (void *) and using %p is probably your best bet.  That's what 
> it really is anyway.
> 
> Note: in the kernel right now, %p doesn't have the leading 0x prefix, 
> which it probably should...

Well, that won't exactly be the nicest looking solution in places, maybe
a shorthand could be developed for this, or could another format
specifier be added that implicitly does the (void *) cast? (%P perhaps)

Harvey

