Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbZBESc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbZBESc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759815AbZBEScE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:32:04 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:16606 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759680AbZBEScA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:32:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MrZaMRY7IHK+qddnozJOyOGiAJN7Dg+gYsOTTe0NtupncuMwssWVWDE2+4UdkEYIeE
         Yn0cLEM+qufMB9As6R3TUYHJuSvsUeuI2VjpRlJdHpaqp21xLvQPiOBEBUidB2fSZEwS
         25bro0K2zqFXGNBXXARVBUM1TwdIupkXeynIE=
MIME-Version: 1.0
In-Reply-To: <20090205181534.GC5661@elte.hu>
References: <1233765552.16414.6.camel@localhost.localdomain>
	 <86802c440902041212q51f2a444l84e1ac29ee6f702e@mail.gmail.com>
	 <20090204212517.GM22608@elte.hu> <498A4DFB.7040608@kernel.org>
	 <20090205181534.GC5661@elte.hu>
Date: Thu, 5 Feb 2009 10:31:58 -0800
X-Google-Sender-Auth: 8f15f7736430f998
Message-ID: <86802c440902051031l78e4cb25va1b0e6274205a3a0@mail.gmail.com>
Subject: Re: [PATCH] x86/pci: host mmconfig detect clean up v2
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ed Swierk <eswierk@aristanetworks.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 10:15 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> Impact: not assume one place for mmconfig in nb
>>
>> prepare for following case: amd fam10h + mcp55
>> CPU MSR has some range, mcp55 pci config will have another one.
>>
>> also prepare for mcp55 + io55 system. every one will have one range.
>>
>> if it s mcp55 detect duties to execlude range that is used by CPU MSR
>> aka, if CPU state bus 0-255, range in mcp55 need to be dropped.
>> because HW in CPU will not route that mcp55 mmconfig to handle it.
>>
>> v2: fix e7520 exit path
>>
>> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
>>
>> ---
>>  arch/x86/pci/mmconfig-shared.c |   98 ++++++++++++++++++++++-------------------
>>  1 file changed, 54 insertions(+), 44 deletions(-)
>
> looks good to me. One for the PCI tree?
>
> Acked-by: Ingo Molnar <mingo@elte.hu>
>
should go with Ed's updated patch before.

to tip or pci tree.

YH
