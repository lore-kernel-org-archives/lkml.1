Return-Path: <linux-kernel-owner+w=401wt.eu-S1762411AbXJFDcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762411AbXJFDcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 23:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXJFDcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 23:32:35 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:49383 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbXJFDce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 23:32:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XngTTcL7hSOGgJQ6z9FBhXWWDmYu1RYSzLjWEkSUUhzpoaQxwFv5kJ3zinsHAQxWLznjR9Lw/cpbrs4MbRy4CELQczN4iy6a9Ujc1FoSWaycYB62/Kk+hSRcQFbeFgOYNSHN3B+94DCtnTSLZ60qC9aG4OEZzk7OiuTV/xDmSMg=
Message-ID: <79759ec90710052032r577b9fey92f024d3908a56b5@mail.gmail.com>
Date: Fri, 5 Oct 2007 20:32:32 -0700
From: "Scott Simpson" <simpson100@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Conflict when loading initio driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Humm not a collision - thats a bug in the driver updating. Looks like the
> changes I made and combined with Christoph's lost a line somewhere when I
> was merging it all. Try the following
>
> Signed-off-by: Alan Cox <alan@redhat.com>
>
> diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.23rc8-mm1/drivers/scsi/initio.c linux-2.6.23rc8-mm1/drivers/scsi/initio.c
> --- linux.vanilla-2.6.23rc8-mm1/drivers/scsi/initio.c	2007-09-26 16:46:54.000000000 +0100
> +++ linux-2.6.23rc8-mm1/drivers/scsi/initio.c	2007-09-30 22:22:03.839113616 +0100
> @@ -2867,6 +2867,7 @@
>  	}
>  	host = (struct initio_host *)shost->hostdata;
>  	memset(host, 0, sizeof(struct initio_host));
> +	host->addr = pci_resource_start(pdev, 0);
>
>  	if (!request_region(host->addr, 256, "i91u")) {
>  		printk(KERN_WARNING "initio: I/O port range 0x%x is busy.\n", host->addr);

I tried this fix on my SuSE 10.3 system (2.6.22.5-29 kernel) and it
didn't work. The system froze on boot. I think there might be more to
it.
     Scott
