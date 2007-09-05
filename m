Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbXIEUmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbXIEUmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbXIEUlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:41:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:21791 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbXIEUle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=RXO13xxe/BSEILb9s0kYz3yG3dv2MLtb7YHjSkiKzTNS+rPC/xEWv9nSa+1YVtnSIFdum6JJ9LJFm6ya3dpQnyGZzLeZTQxYPUu0/H4RPoUoKNKXVQAiZhM10mKnb9/wC/thwTmP3X4HWZq2Am/SxD8BiprL91g4xRQeHs3RBMA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: linux-2.6.23-rc4 ppc build failure
Date: Wed, 5 Sep 2007 22:17:56 +0200
User-Agent: KMail/1.9.6
Cc: Bret Towe <magnade@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <dda83e780708290941g1685879bned63a77d6b0fd242@mail.gmail.com> <dda83e780708301456y72bc4080qc994f4797a5fefd1@mail.gmail.com> <20070831033528.GN10345@bakeyournoodle.com>
In-Reply-To: <20070831033528.GN10345@bakeyournoodle.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709052217.56590.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 August 2007, Tony Breeds wrote:
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

The problem might be related with switching CONFIG_IDE to use menuconfig.

> I ask because if we have other users our there that have working system
> with BLK_DEV_IDE=m it'd be nice to have make oldconfig fix them.  If
> it's just a matter of not letting people get into that state then
> something like the patch below will probably help.

Unlikely that there are working BLK_DEV_IDE=m setups - these missing
symbols (pmac_ide_get_base and friends) have never been exported (IIRC).

> Ensure that BLK_DEV_IDE is built-in befoer allowing BLK_DEV_IDE_PMAC to
> be selected.
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

applied with s/befoer/before/ as spotted by Bret

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
>  	bool "Builtin PowerMac IDE support"
> -	depends on PPC_PMAC && IDE=y
> +	depends on PPC_PMAC && IDE=y && BLK_DEV_IDE=y
>  	help
>  	  This driver provides support for the built-in IDE controller on
>  	  most of the recent Apple Power Macintoshes and PowerBooks.
