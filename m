Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYFZGcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYFZGcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 02:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYFZGci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 02:32:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:57661 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbYFZGch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 02:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QcgjsHcNTHvD9MPwttdawMNFYY6OJnz/SQcCI2Z1E12G3IVtYTX3/UyvRlIB+/EEav
         XaUejF/JDFEClUjzNEM4REbpZhKmT2+Erv8wJXCTpLww7wss16zf5UXHhgHEJvGxhgde
         5Dsn6nvMom3//o0vqgpEBA0ekrw7itzQxPxKc=
Message-ID: <e2e108260806252332k3ffe3c63o29556f5b9d89c4a3@mail.gmail.com>
Date: Thu, 26 Jun 2008 08:32:35 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [10 PATCHES] inline functions to avoid stack overflow
Cc: mpatocka@redhat.com, helge.hafting@aitel.hist.no,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
In-Reply-To: <20080625.150931.182895076.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
	 <486216E7.8000002@aitel.hist.no>
	 <Pine.LNX.4.64.0806250843460.20379@engineering.redhat.com>
	 <20080625.150931.182895076.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 12:09 AM, David Miller <davem@davemloft.net> wrote:
> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Wed, 25 Jun 2008 08:53:10 -0400 (EDT)
>
>> Even worse, gcc doesn't use these additional bytes. If you try this:
>>
>> extern void f(int *i);
>> void g()
>> {
>>          int a;
>>          f(&a);
>> }
>>
>> , it allocates additional 16 bytes for the variable "a" (so there's total
>> 208 bytes), even though it could place the variable into 48-byte
>> ABI-mandated area that it inherited from the caller or into it's own
>> 16-byte padding that it made when calling "f".
>
> The extra 16 bytes of space allocated is so that GCC can perform a
> secondary reload of a quad floating point value.  It always has to be
> present, because we can't satisfy a secondary reload by emitting yet
> another reload, it's the end of the possible level of recursions
> allowed by the reload pass.

Is there any floating-point code present in the Linux kernel ? Would
it be a good idea to add an option to gcc that tells gcc that the
compiled code does not contain floating-point instructions, such that
gcc knows that no space has to be provided for a quad floating point
value ?

Bart.
