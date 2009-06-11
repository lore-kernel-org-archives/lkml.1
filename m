Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbZFKS0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbZFKS0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZFKS0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:26:32 -0400
Received: from h155.mvista.com ([63.81.120.155]:3480 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754820AbZFKS0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:26:32 -0400
Message-ID: <4A314CB6.5090004@ru.mvista.com>
Date: Thu, 11 Jun 2009 22:28:06 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/2 resend] libata-sff: avoid byte swapping in ata_sff_data_xfer()
References: <200902152230.38271.sshtylyov@ru.mvista.com> <49DB199C.3040305@ru.mvista.com> <4A242C81.3080309@ru.mvista.com> <4A314AC7.40300@pobox.com>
In-Reply-To: <4A314AC7.40300@pobox.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jeff Garzik wrote:

>> Hello, I wrote:

>>>> Handling of the trailing byte in ata_sff_data_xfer() is suboptimal 
>>>> bacause:

>>>> - it always initializes the padding buffer to 0 which is not really 
>>>> needed in
>>>>   both the read and write cases;

>>>> - it has to use memcpy() to transfer a single byte from/to the 
>>>> padding buffer;

>>>> - it uses io{read|write}16() accessors which swap bytes on the big 
>>>> endian CPUs
>>>>   and so have to additionally convert the data from/to the little 
>>>> endian format
>>>>   instead of using io{read|write}16_rep() accessors which are not 
>>>> supposed to
>>>>   change the byte ordering.
>>>>
>>>> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

>>>   Jeff, have you forgotten about this one?

>>    PING.

> This has been queued to libata-dev.git#upstream, i.e. linux-next queue, 

    Ah, haven't looked there, so it appeared as forgotten since I know you 
usually reply with 'applied'.

> for a long time.  Apologies if I forgot the 'applied' reply.

> Just sent this upstream, as linux-ide should show.

    Thanks. I began to think of reworking it to avoid even io*_rep() as per 
my followup mail and resending... well, it's good enogh as is. :-)

>     Jeff

MBR, Sergei
