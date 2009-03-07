Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZCGHbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZCGHbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 02:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZCGHbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 02:31:20 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:2433 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZCGHbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 02:31:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FwB58731k9QBUV2XNMaSPFjdgqef/5sgLvspAbb7GKrpICKGqKyXNjkT2dpY9cHGfH
         EftH1rdLMmVX2hl1nriooAMJbpJWay7twGYH8sqEEMmbPll929CvOYCEUSF+62fw/h4o
         BtLajKsVlH4nXE0CnC1tks2wT9yyIA6wlA1fk=
MIME-Version: 1.0
In-Reply-To: <4807377b0903062318q15ba52a7n82d4c9399b8a7fa8@mail.gmail.com>
References: <49B1F934.5050006@kernel.org>
	 <4807377b0903062318q15ba52a7n82d4c9399b8a7fa8@mail.gmail.com>
Date: Fri, 6 Mar 2009 23:31:17 -0800
X-Google-Sender-Auth: e6cfa3828afa0387
Message-ID: <86802c440903062331j22aa57c7r93c84da880a8e572@mail.gmail.com>
Subject: Re: [PATCH] igb: fix kexec with igb
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 11:18 PM, Jesse Brandeburg
<jesse.brandeburg@gmail.com> wrote:
> On Fri, Mar 6, 2009 at 8:33 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> Impact: could probe igb
>>
>> Found one system with 82575EB, in the kernel that is kexeced, probe igb
>> failed with -2.
>>
>> it looks like the same behavior happened on forcedeth.
>>
>> try to check system_state to make sure if put it on D3
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  drivers/net/igb/igb_main.c |   19 ++++++++++++++-----
>>  1 file changed, 14 insertions(+), 5 deletions(-)
>
> I see the point of the patch, but I know for a fact that ixgbe when
> enabled for MSI-X also doesn't work with kexec.
>
> so my questions are:
> are you going to change every driver?

i tend to only change driver that i have related HW.

> why can't this be fixed in core kernel code instead?
will check it.

> Shouldn't pci_enable_device take it out of D3?
> Or maybe it should be taken out of D3 immediately if someone tries to
> ioremap any of the BARx registers?


looks like second kernel can not detect the state any more.

YH
