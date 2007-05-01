Return-Path: <linux-kernel-owner+w=401wt.eu-S965638AbXEAH6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965638AbXEAH6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 03:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965641AbXEAH6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 03:58:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:22116 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965638AbXEAH6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 03:58:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EFCFLUHKlFgpXOpyIfac+TN9n3PHzQhaYJ/CpxF6klRHyStfc9j5JOYBIXstmxo73B0hdDCC8nwzBgBRPU3hgD0sQrP79HqvALMdKFfWxtBebnDNDLAvEjF8wwJCoxVAG8lLON8zWOIaBAjoxCP0nfNMcAh5frqhncaws8ui8Wg=
Message-ID: <4636F337.3060702@gmail.com>
Date: Tue, 01 May 2007 09:58:47 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: dann frazier <dannf@hp.com>, linux-kernel@vger.kernel.org,
       support@moxa.com.tw, dilinger@debian.org
Subject: Re: old buffer overflow in moxa driver
References: <20070430224829.GI31283@krebs.dannf> <20070501000455.2173b1e2@the-village.bc.nu>
In-Reply-To: <20070501000455.2173b1e2@the-village.bc.nu>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox napsal(a):
>>   I noticed that the moxa input checking security bug described by
>> CVE-2005-0504 appears to remain unfixed upstream.
>>  
>> The issue is described here:
>>   http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2005-0504
>>
>> Debian has been shipping the following patch from Andres Salomon. I
>> tried contacting the listed maintainer a few months ago but received
>> no response.
> 
> 
>        case MOXA_LOAD_BIOS:
>         case MOXA_FIND_BOARD:
>         case MOXA_LOAD_C320B:
>         case MOXA_LOAD_CODE:
>                 if (!capable(CAP_SYS_RAWIO))
>                         return -EPERM;
>                 break;
> 
> At the point you abuse these calls you can already just load arbitary
> data from userspace anyway.

The problem is that we BUG_ON, when len < 0 in copy_from_user which is unlikely
something we want to cause?

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
