Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbYKNNOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbYKNNOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 08:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYKNNOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 08:14:24 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:20929 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYKNNOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 08:14:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TWEU3FAKl4ZBfSlsUJNpbEiMhbKA4+rsrm6v1Ta8Z0zDqAcYTh05UIsF3SkxGoYIjN
         g5oDRy05BBYVOjECmxLZChhVptP0SMCRlx/iJMQME/lj/kf60AfzsxQSmDSBftwHfbSc
         RCtUz9LuV1kBX+st6CAw64OcXGZl2S6qMoq4A=
Message-ID: <3aaafc130811140514u4e290b41t78da818d304fce86@mail.gmail.com>
Date: Fri, 14 Nov 2008 08:14:22 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Olaf van der Spek" <olafvdspek@gmail.com>
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
Cc: "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <b2cc26e40811140106n6d43669bn9525754abd1da877@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
	 <3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com>
	 <b2cc26e40811140051n4e821fddsc5504eedcccc9cdc@mail.gmail.com>
	 <491D3CD5.5020105@cosmosbay.com>
	 <b2cc26e40811140106n6d43669bn9525754abd1da877@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 4:06 AM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> On Fri, Nov 14, 2008 at 9:54 AM, Eric Dumazet <dada1@cosmosbay.com> wrote:
>>> I expected the kernel to copy data directly from user-space of the
>>> sending process to a kernel buffer of the receiving process, much like
>>> UNIX sockets.
>>>
>>
>> localhost uses a standard network device, and whole network stack
>> is used, no 'special kludges'. You can add iptables rules, you
>> can do trafic shaping, trafic sniffing (tcpdump), limiting
>> memory used by all sockets (controlling memory pressure on the
>> machine)
>>
>> Doing what you suggest would slow down AF_INET stack.
>
> Why?

Because then the AF_INET stack would have to check *every* time
something went through it and see if it's bound for localhost. You're
adding more complexity to the stack just to make the time on 1 case
speed up, but you're slowing down every single other case.

>
>> You probably can expect AF_UNIX to be faster, since this one is really
>> special and use shortcuts.
>>
>> Then, you probably can use shared memory instead of AF_UNIX, or
>> pipes (and splice()), or ...
>>
>> Then you probably can use threads and do zero-copy ;)
>
> Hmm, I'd like to avoid running my web server inside of my database
> server process. ;)
>
