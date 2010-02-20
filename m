Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0BTNvx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 08:51:53 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:43046 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab0BTNvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 08:51:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=MuAmHiXqK8HebugdCyA+sAzL/479DqBNP4Nfu4kxFXqU3KY937ccEwcvI/HwHI8nvj
         4U1goxLxWuatVKgBHxY09YYaXdNAD4EaDJnvvvvP04DhVXxh+WuhKIpirBqnEMU9makP
         kt4gFPOLU2PmEkpulU5uB0ThhbtRgn7wdDecQ=
Date: Sat, 20 Feb 2010 21:54:31 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       ebiederm@xmission.com, gregkh@suse.de
Subject: Re: sysfs lockdep complaint
Message-ID: <20100220135431.GC3000@hack>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net> <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com> <1266664429.11514.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1266664429.11514.3.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 12:13:49PM +0100, Johannes Berg wrote:
>On Sat, 2010-02-20 at 17:26 +0800, Américo Wang wrote:
>
>> This should be fixed by the patchset from Eric:
>> 
>> http://lkml.org/lkml/2010/2/11/334
>
>That patchset doesn't even compile.
>

Wow. I didn't notice that.

Eric, could you fix your last patch? I mean your patch 4/4, probably.

Greg?


>johannes
>
>---
> drivers/pci/pci-sysfs.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>--- wireless-testing.orig/drivers/pci/pci-sysfs.c	2010-02-20 12:12:28.207979616 +0100
>+++ wireless-testing/drivers/pci/pci-sysfs.c	2010-02-20 12:12:54.588603464 +0100
>@@ -642,7 +642,7 @@ void pci_create_legacy_files(struct pci_
> 	if (!b->legacy_io)
> 		goto kzalloc_err;
> 
>-	sysfs_bin_attr_init(&b->legacy_io);
>+	sysfs_bin_attr_init(b->legacy_io);
> 	b->legacy_io->attr.name = "legacy_io";
> 	b->legacy_io->size = 0xffff;
> 	b->legacy_io->attr.mode = S_IRUSR | S_IWUSR;
>@@ -655,8 +655,8 @@ void pci_create_legacy_files(struct pci_
> 		goto legacy_io_err;
> 
> 	/* Allocated above after the legacy_io struct */
>-	sysfs_bin_attr_init(&b->legacy_mem);
> 	b->legacy_mem = b->legacy_io + 1;
>+	sysfs_bin_attr_init(b->legacy_mem);
> 	b->legacy_mem->attr.name = "legacy_mem";
> 	b->legacy_mem->size = 1024*1024;
> 	b->legacy_mem->attr.mode = S_IRUSR | S_IWUSR;
>
>

-- 
Live like a child, think like the god.
 
