Return-Path: <linux-kernel-owner+w=401wt.eu-S1763947AbXGPAaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763947AbXGPAaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbXGPAaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:30:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:40023 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759162AbXGPAa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:30:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=q8to5PQoezxGp0c66sffSXpMOC95ECVVFbzqtcKdpYnx02OGBBP9vt6e8XSy3oKUdKxS+KtFzVgxPn2KPr22P8COD2fM5hOlXYobUYUx/c+2KWvvum84L/oOBG8HxWuq7FG5llBjDRaTDtlZrh6ov2sE4wpskyAm4ALBbrj+oVo=
Message-ID: <f158dc670707151730w5fedb53fq11367d1e6fb14d87@mail.gmail.com>
Date: Sun, 15 Jul 2007 18:30:27 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [V9fs-developer] [GIT PULL] 9p Patches for 2.6.23 merge window
Cc: "Eric Van Hensbergen" <ericvh@gmail.com>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0707151645561.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4e6962a0707141320p376e51fcp4b1ceb681960e303@mail.gmail.com>
	 <alpine.LFD.0.999.0707151645561.20061@woody.linux-foundation.org>
X-Google-Sender-Auth: 46027edb463df2f9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I thought that it is not a good idea to keep the v9fs_ prefix for code
that is in different places (fs/9p and net/9p). If keeping the old
prefix is more acceptable, I can create a new patch without the
"v9fs_"->"p9_" renames.

Thanks,
    Lucho

On 7/15/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 14 Jul 2007, Eric Van Hensbergen wrote:
> >
> > The bulk of the changes were in the reorganization patch which mostly
> > moved files and interfaces around in preparation for work on an
> > in-kernel 9p server.
>
> Please use "git diff -C --stat --summary" to generate the diffstat
> summary.
>
> In particular, because you didn't use -C (or -M), git have you an
> old-style diffstat without renames, so the diffstat doesn't show that a
> lot of it was moving code around.
>
> (That said, you seem to have changed names a lot too, so it's not pure
> code movement).
>
> > 49 files changed, 5400 insertions(+), 5092 deletions(-)
>
> With rename detection enabled, I get
>
>  36 files changed, 3444 insertions(+), 3130 deletions(-)
>
> due to finding some (partially dubious) renames:
>
>  rename fs/9p/mux.h => include/net/9p/conn.h (53%)
>  rename {fs => include/net}/9p/transport.h (59%)
>  rename {fs => net}/9p/conv.c (55%)
>  rename {fs => net}/9p/fcprint.c (64%)
>  rename {fs => net}/9p/mux.c (55%)
>
> even though is misses a lot of others (due to all the "v9fs" -> "p9"
> changes in the source code too - was that really worth it?).
>
>                         Linus
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by DB2 Express
> Download DB2 Express C - the FREE version of DB2 express and take
> control of your XML. No limits. Just data. Click to get it now.
> http://sourceforge.net/powerbar/db2/
> _______________________________________________
> V9fs-developer mailing list
> V9fs-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/v9fs-developer
>
