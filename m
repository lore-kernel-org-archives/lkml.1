Return-Path: <linux-kernel-owner+w=401wt.eu-S1763169AbXHaF1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763169AbXHaF1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbXHaF05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:26:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:2579 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbXHaF05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:26:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dQB6zHSIYFRSLDDsWlc/kLvU4fieuL9QfOlnX+FuQo8H5BPOhfZK94iQSitJ+R1DkHFr7J/DkQFvblPHlKXf6++FRHKag9KmH4nsqLYGqVHCCD0ghM1TFWbDgjLy4lk218Y2lW4A9o7eA5Isip2LFWNiNAOuiZITn5QV8fhb2JE=
Message-ID: <dda83e780708302226l7ec4c2d0p44ce39d02640f8f8@mail.gmail.com>
Date: Thu, 30 Aug 2007 22:26:55 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Tony Breeds" <tony@bakeyournoodle.com>
Subject: Re: linux-2.6.23-rc4 ppc build failure
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070831033528.GN10345@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780708290941g1685879bned63a77d6b0fd242@mail.gmail.com>
	 <dda83e780708301456y72bc4080qc994f4797a5fefd1@mail.gmail.com>
	 <20070831033528.GN10345@bakeyournoodle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/30/07, Tony Breeds <tony@bakeyournoodle.com> wrote:
> On Thu, Aug 30, 2007 at 02:56:50PM -0700, Bret Towe wrote:
> > On 8/29/07, Bret Towe <magnade@gmail.com> wrote:
> > > while trying to build a fresh kernel for my mini after upgrading from gutsy
> > > (and forgetting to save my .config) I hit the below build error
> > > 2.6.23-rc3 I did work under feisty but that is with a different .config
> > > so not sure if that makes any difference or not
> > > I've not bisected cause it takes so long on this computer...
> > > attached is the config I'm working off now
>
> So how did you generate the new .config?  Did you start with a defconfig
> of some sort and then alter to personal taste?

took the ubuntu config for the current kernel and starting getting rid
of everything i don't need
so the ubuntu config must of had the item set to M before hand

> I ask because if we have other users our there that have working system
> with BLK_DEV_IDE=m it'd be nice to have make oldconfig fix them.  If
> it's just a matter of not letting people get into that state then
> something like the patch below will probably help.

I was thinking the same thing
would you like a test of this?

> Ensure that BLK_DEV_IDE is built-in befoer allowing BLK_DEV_IDE_PMAC to
> be selected.

s/befoer/before  ?

> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
>
> ---
>
>  drivers/ide/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
> index e049f65..e55be26 100644
> --- a/drivers/ide/Kconfig
> +++ b/drivers/ide/Kconfig
> @@ -780,7 +780,7 @@ endif
>
>  config BLK_DEV_IDE_PMAC
>         bool "Builtin PowerMac IDE support"
> -       depends on PPC_PMAC && IDE=y
> +       depends on PPC_PMAC && IDE=y && BLK_DEV_IDE=y
>         help
>           This driver provides support for the built-in IDE controller on
>           most of the recent Apple Power Macintoshes and PowerBooks.
>
> Yours Tony
>
>   linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
>   Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!
>
>
