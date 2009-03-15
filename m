Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbZCOLwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbZCOLwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 07:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758354AbZCOLwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 07:52:08 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:61204 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867AbZCOLwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 07:52:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wb0GYWXCu4i9xFG/NsiC9I0PPgMDnrzf17MHTS5yLq9XMYpUXFLBRrzru6BfA11/vv
         HDDwSkGb7LHPPdQgIEvzj606PRzcvYfcAVHYIrsUbBI0Pfgxktpv2ml1miArjqR1qbqQ
         etTLiJkc41DyAumSHp0p3Tsb80RGT5qze+EBQ=
Message-ID: <49BCEBE0.4080802@gmail.com>
Date: Sun, 15 Mar 2009 12:52:00 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: [PATCH 1/1] Char: moxa, fix refcounting in moxa_poll_port
References: <49BCCAE0.6010303@gmail.com>	<1237109768-3820-1-git-send-email-jirislaby@gmail.com> <20090315105530.6f1782be@lxorguk.ukuu.org.uk>
In-Reply-To: <20090315105530.6f1782be@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restoring CCs.

On 15.3.2009 11:55, Alan Cox wrote:
> On Sun, 15 Mar 2009 10:36:08 +0100
> Jiri Slaby<jirislaby@gmail.com>  wrote:
>
>> There is missing tty_kref_put on some paths in moxa_poll_port,
>> although the reference is always taken. Fix it.
>>
>> Signed-off-by: Jiri Slaby<jirislaby@gmail.com>
>> Reported-by: Jan 'Yenya' Kasprzak<kas@fi.muni.cz>
>> Cc: Alan Cox<alan@lxorguk.ukuu.org.uk>
>
> Acked-by: Alan Cox<alan@lxorguk.ukuu.org.uk>

BTW the same sha, the change in isicom_shutdown_port doesn't seem to be 
quite right too. Well, the change itself is, but not in the code 
context. The tty is used even after tty_port_tty_set(NULL). This is 
wrong, isn't it?
