Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbYGATMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbYGATMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbYGATM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:12:29 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:2158 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbYGATM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CyjoNuLkinZw+0BO6UXGZeMBD7UIg7trrINzQh8qCr0Ynp4AIWRZfiDbEo7Rd2w1EV
         MKK1uPzhNS47p3Lto5KcWqQYmZPextwpqub3aKbSvCvq0v2b6BdMd/AQYGIMF51SCDhd
         yv4xOUwljKRK+Id1CD4oSqY6IH9OEFHabfzSM=
Message-ID: <19f34abd0807011212w5e95f58aw998c74014f1d6632@mail.gmail.com>
Date: Tue, 1 Jul 2008 21:12:26 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] x86: small unifications of address printing
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <486A7E3D.3050901@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701155217.GA22318@damson.getinternet.no>
	 <87d4lxtq3h.fsf@basil.nowhere.org>
	 <19f34abd0807011146g2bb8baf0q2dbaa9ebe501657e@mail.gmail.com>
	 <486A7E3D.3050901@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 8:58 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
>> Yes, it will, and correctly too:
>>
>>         case 'p':
>>                 flags |= SMALL;
>>                 if (field_width == -1) {
>>                         field_width = 2*sizeof(void *);
>>                         flags |= ZEROPAD;
>>                 }
>>
>> Or did I read this code wrong? field_width is initialized to -1 by
>> default unless overridden. The SMALL flag means lowercase hexadecimal
>> digits.
>
> You're right. The kernel differs from user space/traditional behaviour
> in this regard.

...in this regard _too_ ;-)

I just ran a short test with glibc, and I'm surprised to see that this
implementation is not zero-padding the number.

The C99 standard has this to say:

  "The argument shall be a pointer to void. The value of the pointer is
  converted to a sequence of printing characters, in an implementation-defined
  manner."

so I suppose it's quite alright after all.

Thanks for looking.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
