Return-Path: <linux-kernel-owner+w=401wt.eu-S1764434AbZFQHK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764434AbZFQHK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZFQHKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:10:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:28274 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZFQHKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:10:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FqJVJJc+EaGHYnvc+pKmYv4u/JduAM8kNUM2FXhrTOzvN79O92hZw94ehsBm8yrCNQ
         Uhf8nF6zpMqlsrpAczygtY4405FmUomrkJgjOBt0E7TauknSCN3oNJbvnaFOKgROV8n1
         /49OF9cWp1du03uFs1MgoswUIoON6fujU8vPk=
Message-ID: <4A389512.7060005@gmail.com>
Date: Wed, 17 Jun 2009 09:02:42 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.4 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Char: tty, fix tty_port_block_til_ready waiting
References: <1245179580-25402-1-git-send-email-jirislaby@gmail.com> <20090616233152.41e43277.akpm@linux-foundation.org>
In-Reply-To: <20090616233152.41e43277.akpm@linux-foundation.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2009 08:31 AM, Andrew Morton wrote:
>> --- a/drivers/char/tty_port.c
>> +++ b/drivers/char/tty_port.c
>> @@ -193,7 +193,7 @@ int tty_port_block_til_ready(struct tty_port *port,
>>  {
>>  	int do_clocal = 0, retval;
>>  	unsigned long flags;
>> -	DECLARE_WAITQUEUE(wait, current);
>> +	DEFINE_WAIT(wait, current);
> 
> That won't compile.  DEFINE_WAIT(wait) will though.

Ah, crap. One should teach himself using commit --amend.

Sorry.
