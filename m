Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754435AbYLQRZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYLQRZl (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYLQRZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:25:12 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:43690 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbYLQRZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:25:10 -0500
Date: Wed, 17 Dec 2008 18:26:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: linux-arch@vger.kernel.org,
        Alexander van Heukelum <heukelum@mailshack.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 1/many] PROC macro to annotate functions in assembly files
Message-ID: <20081217172640.GB5436@uranus.ravnborg.org>
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm> <1229505475-10219-2-git-send-email-heukelum@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229505475-10219-2-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 10:17:54AM +0100, Alexander van Heukelum wrote:
> Introduce the PROC macro in the generic header file
> include/linux/linkage.h to annotate functions in assembly
> files. This is a first step to fully annotate functions
> (procedures) in .S-files. The PROC macro complements the
> already existing and being used ENDPROC macro. The generic
> implementation of PROC is exactly the same as ENTRY.
> 
> The goal is to annotate functions, at least those called
> from C code, with PROC at the beginning and ENDPROC at the
> end. This is for the benefit of debugging and tracing. It
> will also allow to introduce a framework to check for
> nesting problems and missing annotations in a later stage
> by overriding ENTRY/END and PROC/ENDPROC in architecture-
> specific code, after the annotation errors have been fixed.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>

I understand where you are coming from with these.
But what I see now is:

ENTRY/END
PROC/ENDPROC
KPROBE_ENTRY/KPROBE_END

And it is not obvious for me reading the comment when I should
expect which one to be used.

Could we try to keep it down to two variants?
And then document when to use which one.

	Sam
