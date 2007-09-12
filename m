Return-Path: <linux-kernel-owner+w=401wt.eu-S933996AbXILLs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996AbXILLs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764676AbXILLsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:48:51 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:31745 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764052AbXILLsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CvP93YXMP3dL/obZHz78Lkm1nZIBI4Ba/jc6sPNim7xWeRGaEanTUftNSl5iPMDONQCrQrwqaGReeQmhCaQFbe3S5+UVGLp4h3veGh8mpZ7HE3bBIQCt2rHaL/wq/j0EKbkREzc/7qXGimUdQhUZfdricZFYguYczdz8HJAB6FA=
Message-ID: <b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com>
Date: Wed, 12 Sep 2007 15:48:49 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH] pci: fix unterminated pci_device_id lists
Cc: "Kees Cook" <kees@ubuntu.com>, linux-kernel@vger.kernel.org,
       "Ben Collins" <bcollins@ubuntu.com>,
       "Michael Wu" <flamingice@sourmilk.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <46E7C91D.3070001@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070912064134.GO7910@outflux.net> <46E7C91D.3070001@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/07, Jeff Garzik <jeff@garzik.org> wrote:
> Kees Cook wrote:
> > This patch against 2.6.23-rc6 fixes a couple drivers that do not
> > correctly terminate their pci_device_id lists.  This results in garbage
> > being spewed into modules.pcimap when the module happens to not have
> > 28 NULL bytes following the table, and/or the last PCI ID is actually
> > truncated from the table when calculating the modules.alias PCI aliases,
> > cause those unfortunate device IDs to not auto-load.
> >
> > Signed-off-by: Kees Cook <kees@ubuntu.com>
>
> ACK

I mut say, non-terminated PCI ids lists are constant PITA. There should be
a way to a) put it in macro[1], so that terminator automatically added, and
b) still allow #ifdef inside table like, e.g. 8139too does.

[1] or not macro, because #ifdef inside macros aren't allowed.
