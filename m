Return-Path: <linux-kernel-owner+w=401wt.eu-S1751910AbYJRIvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbYJRIvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 04:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbYJRIvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 04:51:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:20603 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYJRIvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 04:51:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=uhUViCKrt0ac0ex/0vxbOadB66BqAwvAyO1mwsIK7eSZDMv7fiJXcio4Xh75tcZxBt
         YxaUuAcGa5EK/0fWDDF0MD9fTyQrZ2YI3kXAOzhsfyCTP0DEZ4NlUBbyKp7FpSHz5DOy
         1L0w0w+qv4dEjxe7zhNV8V9fS65R14llMwc/E=
Message-ID: <cfd18e0f0810180151v232f623pdbf0f12cad6532d6@mail.gmail.com>
Date: Sat, 18 Oct 2008 03:51:11 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] Document kernel taint flags properly
Cc: "Randy Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org
In-Reply-To: <20081017225515.GA14133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081017225515.GA14133@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Small corrections below.

On Fri, Oct 17, 2008 at 5:55 PM, Greg KH <greg@kroah.com> wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
>
> This fills in the documentation for all of the current kernel taint
> flags, and fixes the number for TAINT_CRAP, which was incorrectly
> described.
>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  Documentation/sysctl/kernel.txt |   24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
>
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -363,11 +363,21 @@ tainted:
>  Non-zero if the kernel has been tainted.  Numeric values, which
>  can be ORed together:
>
> -  1 - A module with a non-GPL license has been loaded, this
> -      includes modules with no license.
> -      Set by modutils >= 2.4.9 and module-init-tools.
> -  2 - A module was force loaded by insmod -f.
> -      Set by modutils >= 2.4.9 and module-init-tools.
> -  4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
> - 64 - A module from drivers/staging was loaded.
> +   1 - A module with a non-GPL license has been loaded, this
> +       includes modules with no license.
> +       Set by modutils >= 2.4.9 and module-init-tools.
> +   2 - A module was force loaded by insmod -f.
> +       Set by modutils >= 2.4.9 and module-init-tools.
> +   4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
> +   8 - A module was forcefully unloaded from the system by rmmod -f.

s/forcefully/forcibly/

> +  16 - A hardware machine check error occured on the system.

occurred

> +  32 - A bad page was discovered on the system.
> +  64 - The user has asked that the system be marked "tainted".  This
> +       could be because they are running software that directly modifies
> +       the hardware, or for other reasons.
> + 128 - The system has died.
> + 256 - The ACPI DSDT has been overridden with one supplied by the user
> +        instead of using the one provided by the hardware.
> + 512 - A kernel warning has occurred.
> +1024 - A module from drivers/staging was loaded.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
