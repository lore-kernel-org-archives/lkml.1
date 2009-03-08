Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbZCHCUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbZCHCUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 21:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZCHCUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 21:20:25 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:47156 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZCHCUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 21:20:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=lKiazlWzaRVurhW5dArnNuvX8b5qTyjEe+wC1EjULnCufRcXnGINiILl5+5iT/nrj6
         xJfLEBd6YYM5LOTF6TJQwo2PYHasewFmW1uLj7xsYK/SFhz4FWgTt1GjpmBqnxygWOrm
         BmMFu6VIvKBRLrF30hTAwr8jg0T0su7QBbhj0=
Message-ID: <49B32B63.9030106@gmail.com>
Date: Sat, 07 Mar 2009 20:20:19 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Adrian McMenamin <lkmladrian@gmail.com>
CC: Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: printk issue - bug?
References: <8b67d60903071537p10994257obc7cce99028a740c@mail.gmail.com>	 <adaab7wgabs.fsf@cisco.com> <8b67d60903071704j4392cde7mb826531da079430d@mail.gmail.com>
In-Reply-To: <8b67d60903071704j4392cde7mb826531da079430d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian McMenamin wrote:
> 2009/3/7 Roland Dreier <rdreier@cisco.com>:
> 
>> ie offset is a 64-bit type but the printk format for it is %x, which
>> presumably only consumes 32 bits on SH4?  Seems like your code is buggy
>> and you ignored a compiler warning about printk format mismatch?
>>
>>  - R.
>>
> 
> Yes, loff_t is a long long  but why did it work in the first line and
> not the second?

It didn't. You didn't print loff_t in the first printk, and the variable 
size mismatch corrupted the next value being printed in the second one.
