Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYHCDUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYHCDUp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYHCDUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:20:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:19127 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbYHCDUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:20:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=pgiWYtQs2aPhUB8JgkyaT2eNJgYqPzpUqs8htizRxWKyNgF9eTtxSQvoD1YXyOPjXH
         S9FOOcu3OwQPHJq4s2j5JkNtiPu3bygVH19xOUtGu5/zH9KBNv6htbDCjkdB9WRIYw9C
         5d27n2F+LN8GX67fXIw8YF0j1LCSzy5ELaKBE=
Message-ID: <489523DC.2090903@gmail.com>
Date: Sun, 03 Aug 2008 12:19:56 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Elias Oltmanns <eo@nebensachen.de>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
References: <87prp1kvyy.fsf@denkblock.local>	<20080726062142.29070.10413.stgit@denkblock.local>	<4892B8FE.1070400@gmail.com> <20080801233459.11e9b254@lxorguk.ukuu.org.uk>
In-Reply-To: <20080801233459.11e9b254@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> However, SATA or not, there simply isn't a way to abort commands in ATA.
>>  Issuing random command while other commands are in progress simply is
>> state machine violation and there will be many interesting results
>> including complete system lockup (ATA controller dying while holding the
>> PCI bus).  The only reliable way to abort in-flight commands are by
>> issuing hardreset.  However, ATA reset protocol is not designed for
>> quick recovery.  The machine is gonna hit the ground hard way before the
>> reset protocol is complete.
> 
> Actually you cau can issue idle immediate on older ATA devices. I am not
> clear if that was stuck back into the current accelerometer friendly
> drives or not. Would need to check with IBLenovo

Was that something intentional or was it a happy accident?  There can be
bus ownership problem on PATA and on SATA this is much more state logic
on both sides of the cable and I think things like that would be more
difficult to work accidentally.

Thanks.

-- 
tejun
