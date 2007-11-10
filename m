Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbXKJWEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbXKJWEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbXKJWEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:04:47 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:59323 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbXKJWEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:04:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZQmZ4EuoihA9jwKx1XmpzqZwr5LGNvv1V6nBP3w7q8UMvx6xl96PDuZ4T5UGXM8qdyC3wekSx9YsVm3TM94H4KfjuuC82UTpT80xBHpriVxMGe5BEpP/7m6DIVMrsigCQT83Rk9Fu+0sFRY14dtsbKjm7x3o/6ATRzy6HtKkEIE=
Message-ID: <47362AF9.5080009@gmail.com>
Date: Sat, 10 Nov 2007 23:04:41 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org, Frank Seidel <fseidel@suse.de>
Subject: Re: [RFC 13/13] Char: nozomi, cleanup read and write
References: <10551261882075921134.slaby@pripojeni.net> <151715551528512164.slaby@pripojeni.net> <20071110161511.GA21669@stusta.de>
In-Reply-To: <20071110161511.GA21669@stusta.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2007 05:15 PM, Adrian Bunk wrote:
> On Fri, Nov 09, 2007 at 06:51:35PM -0500, Jiri Slaby wrote:
>> ...
>> --- a/drivers/char/nozomi.c
>> +++ b/drivers/char/nozomi.c
>> ...
>> -		if (size_bytes - i == 2) {
>> +		if (unlikely(size_bytes - i == 2)) {
>> ...
> 
> Please don't add likely/unlikely in drivers unless it brings a 
> measurable improvement.

Why? Anyway I think this is the case. The body of the then branch is executed at
most once, while the else branch each time but last. If you write/read 1002
bytes, it means 250:1. ...and it's invoked from interrupt too...

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
