Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbXENJpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbXENJpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbXENJpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:45:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:19864 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbXENJpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NeR9q7Z+Mkgv21n2KaBYnbtfhb+BCpl2v3lyZwz90eejTTemdycw5NLNAlw6lwx5H4nN8KDmrCf5PstJbeyDoIQxdw35Q1E71i1wCIWNE5ehkocFWJ7mKfS7paGmFWiuVX2OU+0hYRZ+Qp1ekR3cyPRyZynpw/MDCyA807Z3iKY=
Message-ID: <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com>
Date: Mon, 14 May 2007 15:15:04 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "James Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Cc: "Dave Jones" <davej@redhat.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
In-Reply-To: <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	 <20070513160608.GA29024@redhat.com>
	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
	 <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
	 <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> [...]
>  config SCSI_WAIT_SCAN
>         tristate
> -       default m
> -       depends on SCSI
> -       depends on MODULES
> +       default m if SCSI=m
> +       default n

Note that this also means SCSI_WAIT_SCAN=n (will not get compiled
and built even as a module) if SCSI=y. But this is perfectly fine, because
I see:

#ifndef MODULE
late_initcall(scsi_complete_async_scans);
#endif

in drivers/scsi/scsi_scan.c anyway, so the async scans will be waited
upon and get complete even when SCSI=y and scsi_scan_type=async,
i.e. you don't really need the scsi_wait_scan module in that case anyway.

Satyam
