Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752301AbYLRJX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbYLRJX0 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 04:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYLRJXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 04:23:10 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56144 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762AbYLRJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 04:23:08 -0500
Message-Id: <1229592186.26511.1290697613@webmail.messagingengine.com>
X-Sasl-Enc: yqqjgthYMIcgwCUthee5HMt1DtSutjtw9v1pWO6ADcij 1229592186
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Jan Beulich" <jbeulich@novell.com>, linux-arch@vger.kernel.org,
        "Alexander van Heukelum" <heukelum@mailshack.com>,
        "Ingo Molnar" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Cyrill Gorcunov" <gorcunov@gmail.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm>
 <1229505475-10219-2-git-send-email-heukelum@fastmail.fm>
 <20081217172640.GB5436@uranus.ravnborg.org>
Subject: Re: [PATCH 1/many] PROC macro to annotate functions in assembly files
In-Reply-To: <20081217172640.GB5436@uranus.ravnborg.org>
Date: Thu, 18 Dec 2008 10:23:06 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 18:26:40 +0100, "Sam Ravnborg" <sam@ravnborg.org>
said:
> On Wed, Dec 17, 2008 at 10:17:54AM +0100, Alexander van Heukelum wrote:
> > Introduce the PROC macro in the generic header file
> > include/linux/linkage.h to annotate functions in assembly
> > files. This is a first step to fully annotate functions
> > (procedures) in .S-files. The PROC macro complements the
> > already existing and being used ENDPROC macro. The generic
> > implementation of PROC is exactly the same as ENTRY.
> > 
> > The goal is to annotate functions, at least those called
> > from C code, with PROC at the beginning and ENDPROC at the
> > end. This is for the benefit of debugging and tracing. It
> > will also allow to introduce a framework to check for
> > nesting problems and missing annotations in a later stage
> > by overriding ENTRY/END and PROC/ENDPROC in architecture-
> > specific code, after the annotation errors have been fixed.
> > 
> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> I understand where you are coming from with these.
> But what I see now is:
> 
> ENTRY/END
> PROC/ENDPROC
> KPROBE_ENTRY/KPROBE_END
> 
> And it is not obvious for me reading the comment when I should
> expect which one to be used.
> 
> Could we try to keep it down to two variants?
> And then document when to use which one.

Hi Sam,

Patches to remove KPROBE_ENTRY and KPROBE_END are currently
in the x86-tree.

PROC/ENDPROC should be used around code.

ENTRY/END should be used around objects which are never
executed, like data arrays.

That should be clear enough, I think. The only catch is how
to decide where to use the annotations at all. I have no
complete answer to that. However, in general it would be
good to annotate any object for which an address can be
found in registers, on the stack or in variables. Doubly
so if addresses are within the object but not exactly at
the start of it. This includes assembly functions called
from C (instruction pointer) and arrays.

The macro's are used to align code and data, to identify the
object as code or data and to add object size information to
the debugging info.

Greetings,
    Alexander

> 	Sam
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Access your email from home and the web

