Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbXIQPcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbXIQPcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 11:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbXIQPce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 11:32:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35920 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbXIQPcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 11:32:33 -0400
Message-ID: <46EE9E08.60604@zytor.com>
Date: Mon, 17 Sep 2007 08:32:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: EDD still failing on some systems with 2.6.23-rc6-git2
References: <46EAA9A1.1080100@redhat.com> <46EAB179.4030805@zytor.com> <46EE99C0.5020106@redhat.com>
In-Reply-To: <46EE99C0.5020106@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> 
> Still fails. And apparently fails on disk 0, because it hangs right
> after printing a zero:
> 
> --- linux-2.6.22.noarch.orig/arch/i386/boot/edd.c
> +++ linux-2.6.22.noarch/arch/i386/boot/edd.c
> @@ -151,6 +151,7 @@ void query_edd(void)
>                  * Scan the BIOS-supported hard disks and query EDD
>                  * information...
>                  */
> +               putchar('0' + (devno - 0x80) % 10);
>                 get_edd_info(devno, &ei);
> 
>                 if (boot_params.eddbuf_entries < EDDMAXNR) {

You know... we actually do have printf()... you don't have to play this
kind of games; you can just printf("Drive %x...\n", devno);

So does this happen ONLY when booting from CD-ROM, or is there any other
case when it fails, too?

	-hpa
