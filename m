Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbYFWQkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbYFWQkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbYFWQkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:40:02 -0400
Received: from [194.117.236.238] ([194.117.236.238]:44689 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbYFWQkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:40:00 -0400
Date: Mon, 23 Jun 2008 19:39:34 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: "Ryan Hope" <rmh3093@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] .gitignore for mm-sources is missing critical files
Message-ID: <20080623193934.6d74ac71@linux360.ro>
In-Reply-To: <48f7fe350806230610y224892e3ob34952b2d8b214a9@mail.gmail.com>
References: <48f7fe350806230610y224892e3ob34952b2d8b214a9@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 09:10:11 -0400
"Ryan Hope" <rmh3093@gmail.com> wrote:

> The .gitignore file in the 2.6.26-rc5-mm3 tar ball is incomplete, it
> causes many important files to not get added to a git repo. The
> patches below fix the issue (sorry they are not all in one diff, it
> took me a few try to figure out all the files needed):

Hi,
 
> diff --git a/f07e4d701ff1fa13f98c21d875f252dc13fa2a42:.gitignore
> b/83ad1010c278a37bcd901dde0f7d2b6981f64f6a:.gitignore
> index
> d24ad506e799a5740d19913a333fc9d64261d9c7..9bb1cb6d825d540bc92dfe5c34343438b860b009
> 100644 --- a/f07e4d701ff1fa13f98c21d875f252dc13fa2a42:.gitignore
> +++ b/83ad1010c278a37bcd901dde0f7d2b6981f64f6a:.gitignore
> @@ -26,6 +26,7 @@ tags
>  TAGS
>  vmlinux*
>  !vmlinux.lds.S
> +!vmlinux.lds.h
>  System.map
>  Module.markers
>  Module.symvers

Check v2.6.26-rc7, I submitted a patch a few days ago and it's already
in. Well, just this hunk.
 
> diff --git a/5ec607502ef909acab4ebe886097523ab4e4e3f5:.gitignore
> b/118a64bfe9c4db302820b83a03cc0388f5d620e5:.gitignore
> index
> 9bb1cb6d825d540bc92dfe5c34343438b860b009..71379c18ff4218ba56fd95baf30ac079590ac587
> 100644 --- a/5ec607502ef909acab4ebe886097523ab4e4e3f5:.gitignore
> +++ b/118a64bfe9c4db302820b83a03cc0388f5d620e5:.gitignore
> @@ -22,11 +22,15 @@
>  #
>  # Top-level generic files
>  #
> +!.mailmap
>  tags
>  TAGS
>  vmlinux*
>  !vmlinux.lds.S
>  !vmlinux.lds.h
> +!vmlinux_32.lds.S
> +!vmlinux_64.lds.S
> +!vmlinux.scr
>  System.map
>  Module.markers
>  Module.symvers
> 
> diff --git a/118a64bfe9c4db302820b83a03cc0388f5d620e5:.gitignore
> b/20c660fa39c48b936c3268dbdf179ff84dbbe365:.gitignore
> index
> 71379c18ff4218ba56fd95baf30ac079590ac587..c50ecc6f3c223b51b856c96009f1b9b6539e163d
> 100644 --- a/118a64bfe9c4db302820b83a03cc0388f5d620e5:.gitignore
> +++ b/20c660fa39c48b936c3268dbdf179ff84dbbe365:.gitignore
> @@ -35,6 +35,7 @@ System.map
>  Module.markers
>  Module.symvers
>  !.gitignore
> +!*.lds
> 
>  #
>  # Generated include files

I'd suggest finding a nice regexp/wildcard to unmask these or to fix
the "vmlinux*" line (likely better). Running 'find . -name vmlinux\*'
shows a few more things that may be prone to exclusion to that rule and
shouldn't.

I already feel bad I didn't fix this more thoroughly when I had the
chance :-). Then again, I stumbled on this while working on another
project and I didn't feel like dwelling on other problems. Go ahead and
save the day :P.


	Cheers,
	Eduard
