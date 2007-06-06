Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbXFFHAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbXFFHAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbXFFHAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:00:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8875 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbXFFHAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:00:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BErHwHyi4a2CkooMCBTXyUl4AOxxUQG/khVHHgcItYy82INWVUvMfIehktPt/ZCwbuFP+jijKLktkqGW02iRH9xZXv3p4lP8PytzLUMv/jnRClYlSSKQAOtU2DMmYQIwLBDFYAocBDYcgMdFegh/hccZtUI3nidDkTShDAUWU0M=
Message-ID: <46665B7A.8020506@gmail.com>
Date: Wed, 06 Jun 2007 09:00:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@google.com>
CC: linux-kernel@vger.kernel.org, Ingo Korb <ingo@akana.de>
Subject: Re: [PATCH 1/3] Char: stallion, don't fail with less than max panels
References: <1058130869771517818@wsc.cz> <20070605171745.1ea5b88f.akpm@google.com>
In-Reply-To: <20070605171745.1ea5b88f.akpm@google.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Tue,  5 Jun 2007 23:20:57 +0200 (CEST)
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> stallion, don't fail with less than max panels
>>
> 
> Why not?
> 
> What problem is this patch fixing, and how does it fix it?
> 
> What are the consequences of not having this patch in the kernel?
> 
> etc.  More complete changlogs, please.

Aah, sorry.

--
Since it's not neccesary to have MAX_PANELS on the card, don't fail to let users
use this card even in this case. Stop the testing for loop instead.
--

> 
>> diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
>> index e45113a..265abad 100644
>> --- a/drivers/char/stallion.c
>> +++ b/drivers/char/stallion.c
>> @@ -2172,7 +2172,7 @@ static int __devinit stl_initech(struct stlbrd *brdp)
>>  		}
>>  		status = inb(ioaddr + ECH_PNLSTATUS);
>>  		if ((status & ECH_PNLIDMASK) != nxtid)
>> -			goto err_fr;
>> +			break;
>>  		panelp = kzalloc(sizeof(struct stlpanel), GFP_KERNEL);
>>  		if (!panelp) {
>>  			printk("STALLION: failed to allocate memory "
> 

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
