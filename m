Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbZFXLnC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbZFXLnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:43:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760170AbZFXLmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:42:00 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:56384 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760248AbZFXLl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rMxwTRYBqrf9drpkzA6Z+yAciNezFoK2tmbtbIniDnHxvy3x4FCHMBtC3YvRkGTC82
         AuIUHY2Ou4a3ofWuIY1maobvHwbr2qWIB8XWvLRSRCpha2Q/g2vbpS1VyiqlrSVERfvK
         KyP1SlmWOvO1nzH1jPT3NL2iGiZYbQpn4uvNc=
Message-ID: <4A4210FC.6010102@gmail.com>
Date: Wed, 24 Jun 2009 13:41:48 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.7 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] Char: tty, fix tty_port_block_til_ready waiting
References: <1245311173-1197-1-git-send-email-jirislaby@gmail.com> <20090623163006.f05b75ee.akpm@linux-foundation.org>
In-Reply-To: <20090623163006.f05b75ee.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2009 01:30 AM, Andrew Morton wrote:
> On Thu, 18 Jun 2009 09:46:13 +0200
>> --- a/drivers/char/tty_port.c
>> +++ b/drivers/char/tty_port.c
>> @@ -193,7 +193,7 @@ int tty_port_block_til_ready(struct tty_port *port,
>>  {
>>  	int do_clocal = 0, retval;
>>  	unsigned long flags;
>> -	DECLARE_WAITQUEUE(wait, current);
>> +	DEFINE_WAIT(wait);
>>  	int cd;
>>  
>>  	/* block if port is in the process of being closed */
> 
> Why is nobody reporting the oopses?

Myaybe because only few drivers use that function. I hit it the first
time I tested cyclades patchset.
