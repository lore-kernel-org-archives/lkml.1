Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbYGRS3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbYGRS3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbYGRS3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:29:02 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:58732 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbYGRS3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:29:00 -0400
Date: Fri, 18 Jul 2008 13:28:50 -0500
From: Nathan Lynch <ntl@pobox.com>
To: John Reiser <jreiser@BitWagon.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, benh@kernel.crashing.org,
       torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, roland@redhat.com
Subject: Re: [PATCH v3] elf loader support for auxvec base platform string
Message-ID: <20080718182850.GO9594@localdomain>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>
 <1216166331-14810-2-git-send-email-ntl@pobox.com>
 <1216276539.7740.309.camel@pasglop>
 <20080717000951.5f8cab37.akpm@linux-foundation.org>
 <20080717221932.GL9594@localdomain>
 <20080717154218.8981035c.akpm@linux-foundation.org>
 <487FD74C.4080603@BitWagon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487FD74C.4080603@BitWagon.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 62A902BC-54F7-11DD-BBF0-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Reiser wrote:
> Andrew Morton wrote:
> > On Thu, 17 Jul 2008 17:19:32 -0500
> > Nathan Lynch <ntl@pobox.com> wrote:
> > 
> > 
> >> [snip]
> >> A new aux vector entry, AT_BASE_PLATFORM, will denote the actual hardware.
> [snip]
> 
> > OK.
> > 
> > But it conflicts directly with the already-queued
> > execve-filename-document-and-export-via-auxiliary-vector.patch

Okay, I can rebase on -mm.


> It seems to me that most of the patch conflicts are mechanical
> and could be merged mechanically.
> 
> However I believe that the documentation change to this comment is important:
> -----
> >  #ifdef __KERNEL__
> > -#define AT_VECTOR_SIZE_BASE (14 + 2) /* NEW_AUX_ENT entries in auxiliary table */
> > +#define AT_VECTOR_SIZE_BASE 17 /* NEW_AUX_ENT entries in auxiliary table */
> > +  /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
> >  #endif
> -----
> I scratched my head for a while to figure out that AT_NOTELF also was
> a subtraction as far as AT_VECTOR_SIZE_BASE was concerned.

John, from your patch:

+#define AT_EXECFN  31	/* filename of program */

How did you arrive at 31 for the value of AT_EXECFN?  I haven't been
able to find out how AT_* values are "allocated", or what the reason
is for the gap between AT_SECURE and AT_SYSINFO.
