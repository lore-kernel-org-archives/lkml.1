Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbXIRMWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbXIRMWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 08:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbXIRMVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 08:21:54 -0400
Received: from webmailfront04.ispgateway.de ([80.67.16.115]:51844 "EHLO
	webmailfront04.ispgateway.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbXIRMVx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 08:21:53 -0400
Message-ID: <20070918142140.gl1biq87k8w4kcww@webmail.df.eu>
Date: Tue, 18 Sep 2007 14:21:40 +0200
From: Clemens Ladisch <clemens@ladisch.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: tapio.laxstrom@iptime.fi, linux-kernel@vger.kernel.org
Subject: Re: drivers/usb/misc/emi*.c have the biggest data objects in the
	whole tree
References: <200709141135.35239.vda.linux@googlemail.com>
In-Reply-To: <200709141135.35239.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: domainFACTORY
X-Originating-IP: 213.238.46.206
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> Hi Tapio,
>
> You are the author of these files. Are you still maintaining them?

His newer email address that I found with Google is dead, too.

> These two object files hold the biggest data objects in the whole   
> Linux kernel
>
> Basically, these are big arrays of the following structures:
>
> typedef struct _INTEL_HEX_RECORD
> {
>         __u32   length;
>         __u32   address;
>         __u32   type;
>         __u8    data[MAX_INTEL_HEX_RECORD_LENGTH];
> } INTEL_HEX_RECORD;
>
> I suggest the following optimizations:
>
> Change structure to
>
> typedef struct _INTEL_HEX_RECORD
> {
>         __u8   type;
>         __u8   length;
>         __u16   address;
>         __u8    data[MAX_INTEL_HEX_RECORD_LENGTH];
> } INTEL_HEX_RECORD __attribute__((__packed__));
>
> Store gzip compressed tables and unpack them at load time.
>
> Declare them const and __initdata.

I have a patch somewhere that moves the firmware code to userspace and changes
the drivers to use request_firmware().


Regards,
Clemens

