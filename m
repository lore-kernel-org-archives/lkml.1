Return-Path: <linux-kernel-owner+w=401wt.eu-S966354AbXEKUGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966354AbXEKUGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbXEKUG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:06:27 -0400
Received: from gw.goop.org ([64.81.55.164]:51240 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760038AbXEKUG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:06:26 -0400
Message-ID: <4644CCB9.3040109@goop.org>
Date: Fri, 11 May 2007 13:06:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.com>
Subject: Re: [patch 2/7] use elfnote.h to generate vsyscall notes.
References: <20070511194725.E37E51F8512@magilla.localdomain>
In-Reply-To: <20070511194725.E37E51F8512@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> I used .balign because .align has inconsistent meaning on some platforms
> (matches .p2align instead of .balign).  Using .align in a
> machine-independent file seems questionable.
>
>
>   

Subject: use balign in elfnote.h

Roland McGrath <roland@redhat.com>:
> I used .balign because .align has inconsistent meaning on some platforms
> (matches .p2align instead of .balign).  Using .align in a
> machine-independent file seems questionable.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Roland McGrath <roland@redhat.com>

---
 include/linux/elfnote.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

===================================================================
--- a/include/linux/elfnote.h
+++ b/include/linux/elfnote.h
@@ -40,16 +40,16 @@
  */
 #define ELFNOTE_START(name, type, flags)	\
 .pushsection .note.name, flags,@note	;	\
-  .align 4				;	\
+  .balign 4				;	\
   .long 2f - 1f		/* namesz */	;	\
   .long 4484f - 3f	/* descsz */	;	\
   .long type				;	\
 1:.asciz #name				;	\
-2:.align 4				;	\
+2:.balign 4				;	\
 3:
 
 #define ELFNOTE_END				\
-4484:.align 4				;	\
+4484:.balign 4				;	\
 .popsection				;
 
 #define ELFNOTE(name, type, desc)		\



