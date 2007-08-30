Return-Path: <linux-kernel-owner+w=401wt.eu-S1763115AbXH3V5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763115AbXH3V5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbXH3V4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:56:52 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:9786 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbXH3V4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XndawJRqV+C0rHkxA/LAXtLGPcbhDRCEHxzScb9BQDblX+hxplios5ojHSndKYvuM3XcAfpC6pQPrkQmRqr4XnVUXmKl1dwMB+8lz3Ucggh2ShbIy2UzT7+2K7xQy/feB8WwNzAGUGVOo86cHHfBZmjG8vEyiIAfgiX3ahtJ5vk=
Message-ID: <dda83e780708301456y72bc4080qc994f4797a5fefd1@mail.gmail.com>
Date: Thu, 30 Aug 2007 14:56:50 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: linux-2.6.23-rc4 ppc build failure
In-Reply-To: <dda83e780708290941g1685879bned63a77d6b0fd242@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780708290941g1685879bned63a77d6b0fd242@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/07, Bret Towe <magnade@gmail.com> wrote:
> while trying to build a fresh kernel for my mini after upgrading from gutsy
> (and forgetting to save my .config) I hit the below build error
> 2.6.23-rc3 I did work under feisty but that is with a different .config
> so not sure if that makes any difference or not
> I've not bisected cause it takes so long on this computer...
> attached is the config I'm working off now
>
> arch/powerpc/platforms/built-in.o: In function `pmac_probe':
> setup.c:(.init.text+0xbba): undefined reference to `pmac_ide_get_base'
> setup.c:(.init.text+0xbbe): undefined reference to `pmac_ide_init_hwif_ports'
> setup.c:(.init.text+0xbc6): undefined reference to `pmac_ide_get_base'
> setup.c:(.init.text+0xbca): undefined reference to `pmac_ide_init_hwif_ports'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make[1]: Leaving directory `/usr/src/linux-2.6'
>
>

turns out the issue was I didn't have 'Enhanced IDE/MFM/RLL
disk/cdrom/tape/floppy support' selected (symbol BLK_DEV_IDE) it was
set as module
current code requires it to be built in
guess drivers/ide/Kconfig needs a touch up?
