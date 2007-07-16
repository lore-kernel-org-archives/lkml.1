Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbXGPVCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbXGPVCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbXGPVCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:02:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:64760 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbXGPVCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KHDnpwL8wY3lDSiGSxG5yalvQ9+J5cHpD29ZZ5lHtwanotgKf/oRQtuVKoStldBkxqEojymakUgdqJ0T+a3uYKWjKqX3+gJLQLpPAxxWBfEWOwspCPJluNzyubIczqmHT1ERwXQSH1g9kLss5RHD0xzl8izLWYD/aJzVWKZv+nM=
Message-ID: <a4e6962a0707161402o3a1e84d2me4fc161778ae3dc2@mail.gmail.com>
Date: Mon, 16 Jul 2007 16:02:32 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Dave Jones" <davej@redhat.com>, linux-kernel@vger.kernel.org,
       "Meelis Roos" <mroos@linux.ee>
Subject: Re: [PATCH] 9p: fix debug compilation error
In-Reply-To: <20070716154939.GA30789@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.SOC.4.64.0707161432480.1471@math.ut.ee>
	 <11845972692586-git-send-email-ericvh@gmail.com>
	 <20070716154939.GA30789@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Dave Jones <davej@redhat.com> wrote:
> On Mon, Jul 16, 2007 at 09:47:49AM -0500, Eric Van Hensbergen wrote:
>  > From: Meelis Roos <mroos@linux.ee>
>  >
>  > With 9P but no 9P debug options, this error occurs:
>  >   CC [M]  fs/9p/v9fs.o
>  > fs/9p/v9fs.c: In function 'v9fs_parse_options':
>  > fs/9p/v9fs.c:134: error: 'p9_debug_level' undeclared (first use in this function)
>  >
>  > The following patch moves the definition of p9_debug_level out of #ifdef
>  > and seems to fix the problem.
>  >
>  > (Original patch took care of the extern definition in the includes, but
>  > not the actual definition in mod.c - ericvh)
>
> Seems somewhat wasteful to include the debug options when the config
> option has been disabled though.
> Wouldn't something like this (untested) make more sense ?

Fair enough.  Looks like I introduced this when I put back the
mount-time debug option.

>
>         Dave
>
> ---
>
> fs/9p/v9fs.c: In function 'v9fs_parse_options':
> fs/9p/v9fs.c:134: error: 'p9_debug_level' undeclared (first use in this function)
>
> Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Eric Van Hensbergen <ericvh@gmail.com>

>
> --- linux-2.6.22.noarch/fs/9p/v9fs.c~   2007-07-16 11:45:56.000000000 -0400
> +++ linux-2.6.22.noarch/fs/9p/v9fs.c    2007-07-16 11:46:12.000000000 -0400
> @@ -131,7 +131,9 @@ static void v9fs_parse_options(char *opt
>                 switch (token) {
>                 case Opt_debug:
>                         v9ses->debug = option;
> +#ifdef CONFIG_NET_9P_DEBUG
>                         p9_debug_level = option;
> +#endif
>                         break;
>                 case Opt_port:
>                         v9ses->port = option;
>
> --
> http://www.codemonkey.org.uk
>
