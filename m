Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753833AbYLQRin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbYLQRin (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYLQRi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:38:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:45074 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYLQRi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:38:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dEnJ8Zz4SDP/gpH5lX+eYqM+ZVg7dvmai3BBcGd+W0v/3QSCVdwo5wPkZxsJ0pY7Fh
         m3I4tu2d/FDe/dcTJOxeFcpjoqwL8PVNajneX7p61fGfmormJXU1QV/Cfl5M52BeDgCe
         K9cH0V+IEzZOC8R9LP1+Cglket3yK2MRT87hE=
Date: Wed, 17 Dec 2008 20:38:24 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>, linux-arch@vger.kernel.org,
        Alexander van Heukelum <heukelum@mailshack.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/many] PROC macro to annotate functions in assembly
	files
Message-ID: <20081217173824.GF8078@localhost>
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm> <1229505475-10219-2-git-send-email-heukelum@fastmail.fm> <20081217172640.GB5436@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217172640.GB5436@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Wed, Dec 17, 2008 at 06:26:40PM +0100]
| On Wed, Dec 17, 2008 at 10:17:54AM +0100, Alexander van Heukelum wrote:
| > Introduce the PROC macro in the generic header file
| > include/linux/linkage.h to annotate functions in assembly
| > files. This is a first step to fully annotate functions
| > (procedures) in .S-files. The PROC macro complements the
| > already existing and being used ENDPROC macro. The generic
| > implementation of PROC is exactly the same as ENTRY.
| > 
| > The goal is to annotate functions, at least those called
| > from C code, with PROC at the beginning and ENDPROC at the
| > end. This is for the benefit of debugging and tracing. It
| > will also allow to introduce a framework to check for
| > nesting problems and missing annotations in a later stage
| > by overriding ENTRY/END and PROC/ENDPROC in architecture-
| > specific code, after the annotation errors have been fixed.
| > 
| > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
| > Cc: Sam Ravnborg <sam@ravnborg.org>
| > Cc: Andrew Morton <akpm@linux-foundation.org>
| 
| I understand where you are coming from with these.
| But what I see now is:
| 
| ENTRY/END
| PROC/ENDPROC
| KPROBE_ENTRY/KPROBE_END
| 
| And it is not obvious for me reading the comment when I should
| expect which one to be used.
| 
| Could we try to keep it down to two variants?
| And then document when to use which one.
| 
| 	Sam
| 

Sam, I think eventually we should get something like this:

- KPROBE will be eliminated and explicit section descriptions
  are to be used
- ENTRY could be used / or renamed for something more descriptive
  and being used aligned jmp targets or in case of procs with
  shared body
- PROC/ENDPROC are to replace old ENTRY/END for procs being called
  mostly from C code

Did I miss something? Does it sound like a good/bad plan?

		- Cyrill -
