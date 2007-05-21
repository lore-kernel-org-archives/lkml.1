Return-Path: <linux-kernel-owner+w=401wt.eu-S1759156AbXEUQkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156AbXEUQkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbXEUQj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:39:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:21594 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbXEUQjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XQixV66cwarqe1m6NaeUQiGmkIjaLbyuIvzb7cPekNQUUVK/VHRB+9NWi3lVtcHFcD20Yr4bANO32IzV3eIlSAjL8Yx2TLOYcnVlHJWBIiapRtlh2yGDDzz+uZHDtEAy1dgE90k23UkF082J3H93gqmg0v6XX3C3j8ScewSzMK0=
Message-ID: <86802c440705210939x2b191a4dm170355b14578d3c@mail.gmail.com>
Date: Mon, 21 May 2007 09:39:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gerd Hoffmann" <kraxel@redhat.com>
Subject: Re: [PATCH]serial: make early_uart to use early_prarm instead of console_initcall
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>, "Andi Kleen" <ak@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <465172EC.3010303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705181900.17101.yinghai.lu@sun.com>
	 <20070520202332.145d93a6.akpm@linux-foundation.org>
	 <86802c440705202129o6fe9fb89l47aef78e973c36c5@mail.gmail.com>
	 <465172EC.3010303@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Gerd Hoffmann <kraxel@redhat.com> wrote:
> What is the point in making that work on x86 additionally to serial
> support in early_printk?  It might make sense to split away the serial
> bits from early_printk.c and move them out of arch/ into -- say --
> drivers/serial/, so other architectures can use that too and we have
> only one serial earlyprintk implementation in the kernel.  Not sure it
> is worth the effort given the code size.

yes, we can drop serial bits from early_printk.c, and use
drivers/serial/8250_early.c and
with "earlycon=uart,io,0x3f8,9600n8", "early=ueart,mmio,0xfe000000,9600n8"

and we can extend other non 8250 compatitable uart to some *_early.c
in the same dir.
So other platform and other uart could be happy to get early console.

YH
