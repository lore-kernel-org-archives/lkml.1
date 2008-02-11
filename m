Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbYBKQkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbYBKQkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbYBKQkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:40:07 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4658 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYBKQkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:40:06 -0500
Date: Mon, 11 Feb 2008 16:40:46 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in checkpatch (on pointers to typedefs?)
Message-ID: <20080211164046.GI11671@shadowen.org>
References: <20080210143240.GA13317@joi> <20080211102339.GD11671@shadowen.org> <47B0725C.30407@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B0725C.30407@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 06:05:48PM +0200, Benny Halevy wrote:
> I saw this too with checkpatch.pl version 0.12
> It seems like checkpatch.pl knows only about types derived
> from @typeList by build_types.
> 
> Example below...
> 
> Benny
> 
> $ cat <<EOF | scripts/checkpatch.pl -
> Signed-off-by: john@smith.net
> ---
> diff a/f.c b/f.c
> --- a/f.c
> +++ b/f.c
> @@ -1,0 +1,2 @@
> +foo(int a, my_uint32 *);
> +bar(int a, my_uint32_t *);

But that isn't actually syntactically correct code is it?  You have types
as parameters like a function declaration, but no return type.  So there
is no hint to checkpatch that this is a function declaration and therefore
the parameters are not expected to be types, nor are they checked as such.

The following diff is clean on the latest version of checkpatch:

Signed-off-by: john@smith.net
---
diff a/f.c b/f.c
--- a/f.c
+++ b/f.c
@@ -1,0 +1,2 @@
+void foo(int a, my_uint32 *);
+int bar(int a, my_uint32_t *);
EOF

Could you try out the version of checkpatch at the URL below on the real
patch you are using to test, and let me know if it works.  There are
a number of improvements to type tracking in the face of ifdef's and
the like.  If it doesn't could I have the hunk which fails:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-next

-apw
