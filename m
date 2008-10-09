Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYJJAU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYJJAU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYJJAUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:20:16 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:48550 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbYJJAUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:20:15 -0400
Date: Thu, 9 Oct 2008 10:56:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: root <thunder7@xs4all.nl>
Cc: linux-fb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Michal Januszewski <spock@gentoo.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] docs: Re: uvesafb in 2.6.27-rc9 uses mode_option, in 2.6.27
 mode, but the docs aren't updated
Message-Id: <20081009105634.ee300093.randy.dunlap@oracle.com>
In-Reply-To: <20081007185410.GA7872@onderneming10>
References: <20081007185410.GA7872@onderneming10>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008 18:54:10 +0000 root wrote:

> I just tested 2.6.27-rc9 on my laptop, which uses uvesafb. I notice that
> I need to update
> 
> /sbin/modprobe uvesafb mode=1400x1050
> 
> to
> 
> /sbin/modprobe uvesafb mode_option=1400x1050
> 
> but the documentation in Documentation/fb/uvesafb.txt happily talks
> about the mode option. It would be nice to have the documentation
> updated at least, but might I also question this move at all? Why call
> something 'mode_option' when 'mode' is shorter and the fact that it's an
> option really is clear from the fact you mention it on the commandline,
> like, how-do-I-call-it, yes-I-remember, an option?

True, but most framebuffer drivers use 'mode_option', so this one was
converted to be more normal.  And I was outvoted.  :(
[I wrote on 2008-FEB-05:
I would (do) say that "mode_option" is being redundant.  Yes, it's
an option, but we don't usually name options (in other parts of the
kernel) with an _option suffix.  Sure, the variable could be called
<mode_option>, but the userspace name should just be "mode".  IMHO.

Please keep Documentation/fb/modedb.txt updated if you make any
relevant changes.
]



> Or are we moving toward 'mtrr_option', 'scroll_option',
> 'vram_remap_option' etc? I don't think that really a good idea, so the
> easiest thing to do would be to revert the patch that did this rename,
> since that resyncs the Documentation to the actual module and removes
> the needless description of the 'mode' option.



From: Randy Dunlap <randy.dunlap@oracle.com>

uvesafb was switched from the 'mode' parameter to the more common (in
fb-land) 'mode_option' parameter, so update the documentation for that.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: root <thunder7@xs4all.nl>
cc: Krzysztof Helt <krzysztof.h1@wp.pl>
cc: Michal Januszewski <spock@gentoo.org>
---
 Documentation/fb/uvesafb.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.27-rc9-git2.orig/Documentation/fb/uvesafb.txt
+++ linux-2.6.27-rc9-git2/Documentation/fb/uvesafb.txt
@@ -52,7 +52,7 @@ are either given on the kernel command l
 
  video=uvesafb:1024x768-32,mtrr:3,ywrap (compiled into the kernel)
 
- # modprobe uvesafb mode=1024x768-32 mtrr=3 scroll=ywrap  (module)
+ # modprobe uvesafb mode_option=1024x768-32 mtrr=3 scroll=ywrap  (module)
 
 Accepted options:
 
@@ -105,7 +105,7 @@ vtotal:n
 <mode>  The mode you want to set, in the standard modedb format.  Refer to
         modedb.txt for a detailed description.  When uvesafb is compiled as
         a module, the mode string should be provided as a value of the
-        'mode' option.
+        'mode_option' parameter.
 
 vbemode:x
         Force the use of VBE mode x.  The mode will only be set if it's
@@ -182,7 +182,7 @@ from the Video BIOS if you set pixclock 
 
 --
  Michal Januszewski <spock@gentoo.org>
- Last updated: 2007-06-16
+ Last updated: 2008-10-09
 
  Documentation of the uvesafb options is loosely based on vesafb.txt.
 
