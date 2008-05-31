Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbYEaKEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbYEaKEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 06:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYEaKDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 06:03:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:13419 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYEaKDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 06:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SbD/HgxHwC8f1iUEJ+5MLJpr3PCmaVXiR9FqptCs/3c56GlvVa47lyvo2lyL+Bxm1l0dmCMDRFrkLVvHyOI+z0re3sIDB+7WJkMevRgSK1aznid6MPuX15i0FhOZkW/DbsPonO1QhWLfh5yMzNYoDRHsC41U6hO5amCtu/15Xr8=
Message-ID: <19f34abd0805310303i526f6b4dv167355103665ac42@mail.gmail.com>
Date: Sat, 31 May 2008 12:03:54 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: righi.andrea@gmail.com
Subject: Re: whomto.pl -- finding out whom to send patches to
Cc: linux-kernel@vger.kernel.org, "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Sverre Rabbelier" <alturin@gmail.com>, "Joe Perches" <joe@perches.com>,
       git@vger.kernel.org
In-Reply-To: <483FB39A.4070104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080529210018.GA5508@damson.getinternet.no>
	 <483FB39A.4070104@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/08, Andrea Righi <righi.andrea@gmail.com> wrote:
> Vegard Nossum wrote:
>
> > Hi,
> >
> > I've written this perl script that takes a patch as input and prints the
> > authors/committers of the affected lines, using git-blame as the back end.

...

> > (Improvements are of course also welcome.)
> >
>
>  Minor fix: do not git-blame /dev/null in patches that add new files.
>
>  -Andrea
>
>  diff -urpN linux/whomto.orig.pl linux/whomto.pl
>  --- linux/whomto.orig.pl        2008-05-30 09:43:08.000000000 +0200
>  +++ linux/whomto.pl     2008-05-30 09:49:26.000000000 +0200
>  @@ -101,6 +101,7 @@ sub parse_patch {
>
>         for (@p) {
>                 if (m/^--- .*?\/([^\s~]*)/) {
>  +                       next if ($1 eq 'dev/null');
>                         $file = $files{$1} = {
>                                 chunks => [],
>                         };
>

I missed that, thanks :-)

(Other diff programs may also use other paths for new files, so I'm
also adding an -f check.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
