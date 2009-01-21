Return-Path: <linux-kernel-owner+w=401wt.eu-S1764826AbZAUL7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764826AbZAUL7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759546AbZAUL7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:59:08 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:36853 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761AbZAUL7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:59:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=CNlDDZjoHkxpk53O0EFwtFnQw+uggkOX0eTDMr6bkWRyDJLwsoy0XmqucPhpuqr9k6
         doXwcaeCfbEVbYFLiSNXZIZ9WVVvewEbvYEb//8ffbMgE3wXJvGWpJb21hEJ7tam6Qdq
         3FY15tVGeJibKtYGftSjHK5VYSqy1sAMQVjyM=
Message-ID: <49770E08.6040204@gmail.com>
Date: Wed, 21 Jan 2009 20:59:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Grant Grundler <grundler@google.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>, linux-pci@vger.kernel.org
Subject: Re: libata, devm_*, and MSI ?
References: <4975F5C1.8090107@rtr.ca>	 <da824cf30901200944x545431b2va0233abc14e81f9b@mail.gmail.com>	 <497614F5.6000301@rtr.ca> <da824cf30901201051v66ae13c4i3476097ee31db281@mail.gmail.com> <49762BF1.2050101@rtr.ca>
In-Reply-To: <49762BF1.2050101@rtr.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mark.

Sorry about slacking off.  Having way too much fun mucking around
assembly code lately.

Mark Lord wrote:
> I believe that other MSI users might want something similar,
> or perhaps Tejun could extend devres to include a pair
> of suitable functions, devm_enable_msi() and  devm_disable_msi().
> Then it would be just automatic for drivers, without any fuss.

devres does handle MSI.  Please take a look at pcim_release() in
drivers/pci/pci.c.  msi/msix enabledness is tracked by
pdev->msi[x]_enabled and if either one was enabled on a managed PCI
device, it would be disabled on driver detach, so there's no reason to
worry about it.

Also, there is no reason for low level driver to dingle with intx.  In
fact, it shouldn't as PCI quirk is supposed to handle all the pretty
quirkiness.  The intx code was there before the quirk code was in
place and no one went after them.  They should go and probably won't
cause any problem in the process.

Thanks.

-- 
tejun
