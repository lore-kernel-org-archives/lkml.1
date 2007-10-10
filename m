Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbXJJOXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbXJJOXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 10:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbXJJOWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 10:22:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:12522 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbXJJOWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 10:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LPTCZl9xhgcc+5RwVUh+PF/eFGY5Mwwqg6OOuLZr6MuOhslYqege3eIMqJUQxsvb5wW7U2OxE5nKzS/CTnyViMvJTq+H1oHEDYiI9LDiU/7AkjYZqfAJW2ekfEKWPov2u0hwPunFM8W7J78Vw4/ZWwY6ddAyTCLArWuSHOMAnw4=
Message-ID: <79759ec90710100722s4384ca79if67167257cb431bc@mail.gmail.com>
Date: Wed, 10 Oct 2007 07:22:52 -0700
From: "Scott Simpson" <simpson100@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Conflict when loading initio driver
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071006111318.1d2aab90@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <79759ec90710052032r577b9fey92f024d3908a56b5@mail.gmail.com>
	 <20071006111318.1d2aab90@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK. I did some debugging in this initio.c driver. I put printk
statements at the beginning of each routine and I got the following
output:

initio_se2_rd
initio_se2_instr
(The previous two routines repeat a bunch of times then I get:)
initio_stop_bm
i91u: PCI Base=0xEC00, IRQ=0, BIOS=0x0000, SCSI ID=7
i91u: Reset SCSI Bus...
initio_reset_scsi
scsi2: Initio INI-9X00U/UW SCSI device driver
i91u_queuecommand
initio_alloc_scb

So it seems to be dieing in initio_alloc_scb. I think it is dieing on
the first spin lock if that makes any sense, but it could be dieing
somewhere else in that routine. Hope this helps.
