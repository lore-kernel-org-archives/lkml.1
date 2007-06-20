Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXFTVGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXFTVGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbXFTVGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:06:34 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:57889 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbXFTVGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fvM/wApUIjlcLP+Jr2arkLX9WTl3w9g6DOdLj0EYmd96SdnJDxqJXHUnjnhr/tjVYIizi/FYh4hpZuqkGv7hmurmaFw+fMD/MFM0cufEpDJuFs56e/LW2U2Gnii0KLtyxaab5U5lCgriAq4BDtxBEoPCOHaz6ioWteZzZrglQRc=
Message-ID: <7b9198260706201406w4a49bb81n5ebb2d45691a6a42@mail.gmail.com>
Date: Wed, 20 Jun 2007 22:06:32 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "=?ISO-8859-1?Q?Toralf_F=F6rster?=" <toralf.foerster@gmx.de>
Subject: Re: linux-2.6.22-rc5-g7c8545e build #298 failed b/c of Section mismatch: reference to .init.text:amd_init_mtrr
Cc: rgooch@atnf.csiro.au, linux-kernel@vger.kernel.org
In-Reply-To: <7b9198260706201304h692e0740i7c4024d54dc35416@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200706202152.48877.toralf.foerster@gmx.de>
	 <7b9198260706201304h692e0740i7c4024d54dc35416@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/07, Tom Spink <tspink@gmail.com> wrote:
> On 20/06/07, Toralf Förster <toralf.foerster@gmx.de> wrote:
> > Hello,
> >
> > the build with the attached .config failed, make ends with:
> <snippedy-doo-dah>
>
> Hi,
>
> The build seems to fail because of:
> ERROR: "ROOT_DEV" [drivers/mtd/maps/nettel.ko] undefined!
>
> After taking a quick look at the code, I can't immediately see why
> this would be, since there is an include for linux/root_dev.h at the
> top, there.
>
> There's only one occurrence of ROOT_DEV (line 425), and after a quick
> look at the git history, it seems the include was originally missing,
> but was put back in, in commit
> 6cc449c7d0292cb9b993f0df84fd3225e3099492.
>
> --
> Regards,
> Tom Spink
> University of Edinburgh
>

Hi,

After further inspection, I *think* it's because nettel is being built
as a module, and it's trying to reference ROOT_DEV, which is not
exported.

-- 
Regards,
Tom Spink
University of Edinburgh
