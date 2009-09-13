Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbZIMAhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbZIMAhY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 20:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZIMAhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 20:37:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:28499 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZIMAhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 20:37:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=DM35n4cvBBbaCcZFr7zEZ2FdK3EmywVq5z1iRMeZIPsEGdOWbdXtfCy8/jjtZNXTY
	qCIr3SE575Rymd2JTymyA==
MIME-Version: 1.0
In-Reply-To: <4AAC3D78.7070806@pobox.com>
References: <8b5805ff0909111906j68c20c3yf7226f2798a67d80@mail.gmail.com> 
	<1252721641.28368.34.camel@desktop> <8b5805ff0909120359g2faf661br463b19518d935110@mail.gmail.com> 
	<4AABD122.2000400@gmail.com> <8b5805ff0909121717w1516c273k2a568779b9c31662@mail.gmail.com> 
	<8b5805ff0909121726g2f1a78c1o1ff7289e059eabe5@mail.gmail.com> 
	<4AAC3D78.7070806@pobox.com>
From: "Jung-Ik (John) Lee" <jilee@google.com>
Date: Sat, 12 Sep 2009 17:37:01 -0700
Message-ID: <8b5805ff0909121737s9f1181cw8d8bf93f9b5c2eed@mail.gmail.com>
Subject: Re: [PATCH] libata: Add pata_atp867x driver for Artop/Acard ATP867X 
	controllers
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Daniel Walker <dwalker@fifo99.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Grant Grundler <grundler@google.com>,
       Gwendal Grignou <gwendal@google.com>, Eric Uhrhane <ericu@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 5:31 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> On 09/12/2009 08:26 PM, Jung-Ik (John) Lee wrote:
>>
>> From: John(Jung-Ik) Lee<jilee@google.com>
>>
>> This is a new pata driver for ARTOP 867X 64bit 4-channel UDMA133 ATA
>> ctrls.
>> Based on the Atp867 data sheet rev 1.2, Acard, and in part on early ide
>> codes
>> from Eric Uhrhane<ericu@google.com>.
>>
>> Signed-off-by: John(Jung-Ik) Lee<jilee@google.com>
>> Reviewed-by:  Grant Grundler<grundler@google.com>
>> Reviewed-by:  Gwendal Gringo<gwendal@google.com>
>> ---
>>
>>  drivers/ata/Kconfig        |    9 +
>>  drivers/ata/Makefile       |    1 +
>>  drivers/ata/pata_atp867x.c |  578
>> ++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/pci_ids.h    |    2 +
>>  4 files changed, 590 insertions(+), 0 deletions(-)
>
> What changed in this patch, versus previous patches?

Only one change - removed the hard-coded value for active/recovery.

 -+#ifdef ATP867X_NO_HACK_PIOMODE
 + b = atp867x_get_active_clocks_shifted(t.active) |
 +  atp867x_get_recover_clocks_shifted(t.recover);
-+#else
-+ /*
-+  * magic value that works (from doc 6.4, 6.6.9)
-+  */
-+ b = 0x31;
-+#endif
 + if (dp->pci66mhz)
 +  b += 0x10;
 +


>
> (that's a question, and also an indication of what needs to be explicitly
> stated in your email body, immediately following the "---" separator, for
> each patch revision)
>

I'll send another with rev change.
-John


> Since the merge window is open, I will likely send this driver upstream as
> soon as feedback level approaches zero.
>
>        Jeff
>
>
>
>
