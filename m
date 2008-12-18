Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753017AbYLRJwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbYLRJwT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 04:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYLRJwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 04:52:00 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44779 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbYLRJv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 04:51:59 -0500
Message-Id: <1229593918.31758.1290707307@webmail.messagingengine.com>
X-Sasl-Enc: jZmSKwbOQyBO9sZA/ydPYOVQLJTSBVLf0GKo+iQX1qh5 1229593918
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Sam Ravnborg" <sam@ravnborg.org>, "Cyrill Gorcunov" <gorcunov@gmail.com>
Cc: "Jan Beulich" <jbeulich@novell.com>, linux-arch@vger.kernel.org,
        "Alexander van Heukelum" <heukelum@mailshack.com>,
        "Ingo Molnar" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Re: [PATCH 1/many] PROC macro to annotate functions in assembly files
In-Reply-To: <20081217180023.GA5783@uranus.ravnborg.org>
Date: Thu, 18 Dec 2008 10:51:58 +0100
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm>
 <1229505475-10219-2-git-send-email-heukelum@fastmail.fm>
 <20081217172640.GB5436@uranus.ravnborg.org>
 <20081217173824.GF8078@localhost>
 <20081217180023.GA5783@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 19:00:23 +0100, "Sam Ravnborg" <sam@ravnborg.org>
said:
> On Wed, Dec 17, 2008 at 08:38:24PM +0300, Cyrill Gorcunov wrote:
> > [Sam Ravnborg - Wed, Dec 17, 2008 at 06:26:40PM +0100]
> > | On Wed, Dec 17, 2008 at 10:17:54AM +0100, Alexander van Heukelum wrote:
> > | > Introduce the PROC macro in the generic header file
> > | > include/linux/linkage.h to annotate functions in assembly
> > | > files. This is a first step to fully annotate functions
> > | > (procedures) in .S-files. The PROC macro complements the
> > | > already existing and being used ENDPROC macro. The generic
> > | > implementation of PROC is exactly the same as ENTRY.
> > | > 
> > | > The goal is to annotate functions, at least those called
> > | > from C code, with PROC at the beginning and ENDPROC at the
> > | > end. This is for the benefit of debugging and tracing. It
> > | > will also allow to introduce a framework to check for
> > | > nesting problems and missing annotations in a later stage
> > | > by overriding ENTRY/END and PROC/ENDPROC in architecture-
> > | > specific code, after the annotation errors have been fixed.
> > | > 
> > | > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> > | > Cc: Sam Ravnborg <sam@ravnborg.org>
> > | > Cc: Andrew Morton <akpm@linux-foundation.org>
> > | 
> > | I understand where you are coming from with these.
> > | But what I see now is:
> > | 
> > | ENTRY/END
> > | PROC/ENDPROC
> > | KPROBE_ENTRY/KPROBE_END
> > | 
> > | And it is not obvious for me reading the comment when I should
> > | expect which one to be used.
> > | 
> > | Could we try to keep it down to two variants?
> > | And then document when to use which one.
> > | 
> > | 	Sam
> > | 
> > 
> > Sam, I think eventually we should get something like this:
> > 
> > - KPROBE will be eliminated and explicit section descriptions
> >   are to be used
> > - ENTRY could be used / or renamed for something more descriptive
> >   and being used aligned jmp targets or in case of procs with
> >   shared body

I don't think ENTRY should be used for nested procedures. If the
author wants to do something like that, he better knew something
about the assembler anyhow.

> > - PROC/ENDPROC are to replace old ENTRY/END for procs being called
> >   mostly from C code

Currently there is many different patterns. Some functions use ENTRY
without END, some use ENTRY/ENDPROC, some use ENDPROC without annotation
at the start...

> So what prevents us from extending ENTRY/END instead of introducing
> another set?

ENTRY/END alone is not enough if one wants to be able to distinguish
between code (functions) and non-executed data.

> Let us try to extend what we have and not introduce something new.

Agreed. I vote to complement the existing ENDPROC annotation with
the proposed PROC annotation. Let's call that an extension, not
something new ;). As it stands it is not impossible to go with
ENTRY/ENDPROC for code and ENTRY/END for data. However, ENTRY
implies alignment and the prefered alignment for code and data
might differ.

Greetings,
    Alexander

> 	Sam
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Access your email from home and the web

