Return-Path: <linux-kernel-owner+w=401wt.eu-S1423060AbXBHO2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423060AbXBHO2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 09:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423007AbXBHO2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 09:28:07 -0500
Received: from wx-out-0506.google.com ([66.249.82.237]:54617 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423060AbXBHO2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 09:28:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PXFos5U3RgSKrOUCuKsmZa10CEWLIIO85i2XLYf9HcjzO96E2YGuYGcQrBeFKgadkJMAa8Z6b/jB9oUClgbUdaqOZxzoX7+sBeP7BekzBTNn+HlbBRSn12Y49rdvZzXkzjNkjzHy+MDseflQqLq8dvSoR1dbtSZVmzulx4PdBmg=
Message-ID: <8bd0f97a0702080628u5038191dm74139a7dd7bff909@mail.gmail.com>
Date: Thu, 8 Feb 2007 09:28:03 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Subject: Re: + search-a-little-harder-for-mkimage.patch added to -mm tree
Cc: akpm@linux-foundation.org, sam@ravnborg.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1HF9zs-0006Ei-2k@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702080607.l1867c0D006861@shell0.pdx.osdl.net>
	 <E1HF9zs-0006Ei-2k@flower>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> proposition is to substitute:
>      "$(CONFIG_SHELL) $(MKIMAGE)"
> with
>      "mkimage"

this isnt a one-to-one change ... let's look at the typical
mkimage-missing scenario ...

with mkuboot.sh you'd get output like:
...
  UIMAGE  arch/blackfin/boot/vmImage
"mkimage" command not found - U-Boot images will not be built
  Building modules, stage 2.
...

with mkimage you'd get output like:
...
  UIMAGE  arch/blackfin/boot/vmImage
/bin/sh: mkimage: command not found
make[1]: *** [arch/blackfin/boot/vmImage] Error 127
make: *** [vmImage] Error 2

so while you could change all the Makefile's to insert - to ignore
*all* failures, without the script, you loose the ability to only
ignore "binary missing" errors
-mike
