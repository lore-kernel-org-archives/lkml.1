Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbXLTEM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbXLTEM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 23:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXLTEMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 23:12:19 -0500
Received: from namei.org ([69.55.235.186]:49299 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754034AbXLTEMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 23:12:18 -0500
Date: Thu, 20 Dec 2007 15:11:40 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: David Chinner <dgc@sgi.com>
cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, dhowells@redhat.com
Subject: Re: [patch, rfc] mm.h, security.h, key.h and preventing namespace
 poisoning
In-Reply-To: <20071220014413.GK4612@sgi.com>
Message-ID: <Xine.LNX.4.64.0712201506520.6851@us.intercode.com.au>
References: <20071219093834.GW4396912@sgi.com> <Xine.LNX.4.64.0712201052110.1736@us.intercode.com.au>
 <20071220014413.GK4612@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007, David Chinner wrote:

> > I'm not sure I understand your namespace pollution issue, either.
> 
> doing this globally:
> 
> #ifdef CONFIG_SOMETHING
> extern int	some_common_name(int a, int b, int c);
> #else
> #define some_common_name(a,b,c)	0
> #endif

I suspect it may be useful ensure all global identifiers for the key 
subsystem are prefixed with key_, as 'copy_keys' does seem a little 
generic.

> > +#ifdef CONFIG_SECURITY
> > +extern unsigned long mmap_min_addr;
> > +#endif
> > +
> >  #include <asm/page.h>
> >  #include <asm/pgtable.h>
> >  #include <asm/processor.h>
> 
> Fine by me.

I'll queue it for -mm & 2.6.25.


- James
-- 
James Morris
<jmorris@namei.org>
