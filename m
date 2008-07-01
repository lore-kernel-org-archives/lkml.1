Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbYGASqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbYGASqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYGASq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:46:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:2422 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbYGASqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=grF0zi0HtfE27k6AAMzS2HrwrcXQMhi6USVmur06Y8UbNa9JZ3FOfn73wIOs4f37PN
         f/qXblKhl4jw3DBda8zM6dZfUgoNfcim2Og5cTbXZ1GcQQOEjTpSZ7UDohvKr2Fa4gez
         TKvDJ5zD4lBrlE2ko2a9OHKZb2tywaRs7z8Qw=
Message-ID: <19f34abd0807011146g2bb8baf0q2dbaa9ebe501657e@mail.gmail.com>
Date: Tue, 1 Jul 2008 20:46:24 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] x86: small unifications of address printing
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87d4lxtq3h.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701155217.GA22318@damson.getinternet.no>
	 <87d4lxtq3h.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 8:29 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Vegard Nossum <vegard.nossum@gmail.com> writes:
>
>> 'man 3 printf' tells me that %p should be printed as if by %#x, but
>> this is not true for the kernel, which does not use the '0x' prefix
>> for the %p conversion specifier.
>
> Problem is that %p will not pad to 8/16 digits. Addresses are traditionally
> padded.

Yes, it will, and correctly too:

        case 'p':
                flags |= SMALL;
                if (field_width == -1) {
                        field_width = 2*sizeof(void *);
                        flags |= ZEROPAD;
                }

Or did I read this code wrong? field_width is initialized to -1 by
default unless overridden. The SMALL flag means lowercase hexadecimal
digits.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
