Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYIXTRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYIXTRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYIXTRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:17:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:21368 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYIXTRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:17:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=aJXMXOjcPLt2nsS3GuF9zrGEtF/hgNOqfpnnicgCQGhsHYTp2tqhq5lgVd1YyyhL0g
         HrFjeg8Ue9beJroO+YGw3mpcj/IwSHdJ0XU0LtitJZwbppjTYmPdj0HHdsmDPOdWI2jG
         o7NWQBvFR42rlkdcpSMWDf4f5/sCl5guE6aWg=
Message-ID: <86802c440809241217p7a79f397v48c76c60eeb8bb16@mail.gmail.com>
Date: Wed, 24 Sep 2008 12:17:18 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>
Subject: Re: [patch 2/3] x86: apic - simplify lapic_get_maxlvt
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>, mingo@elte.hu,
       macro@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <48DA8DC4.90203@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924164618.588609232@gmail.com>
	 <48da6f73.0c07560a.1702.41f4@mx.google.com>
	 <48DA8DC4.90203@ct.jp.nec.com>
X-Google-Sender-Auth: 7bb04e1ccbf6dfe7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 11:58 AM, Hiroshi Shimamoto
<h-shimamoto@ct.jp.nec.com> wrote:
> Cyrill Gorcunov wrote:
>> Lets use lapic_get_version helper and hide
>> register being read. Also it allow us to
>> make code a bit tighter.
>>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>> ---
>>
>> Index: linux-2.6.git/arch/x86/kernel/apic.c
>> ===================================================================
>> --- linux-2.6.git.orig/arch/x86/kernel/apic.c 2008-09-24 19:17:20.000000000 +0400
>> +++ linux-2.6.git/arch/x86/kernel/apic.c      2008-09-24 19:33:31.000000000 +0400
>> @@ -309,14 +309,14 @@ int get_physical_broadcast(void)
>>   */
>>  int lapic_get_maxlvt(void)
>>  {
>> -     unsigned int v;
>> +     unsigned int ver;
>>
>> -     v = apic_read(APIC_LVR);
>> +     ver = lapic_get_version();
>>       /*
>>        * - we always have APIC integrated on 64bit mode
>>        * - 82489DXs do not report # of LVT entries
>>        */
>> -     return APIC_INTEGRATED(GET_APIC_VERSION(v)) ? GET_APIC_MAXLVT(v) : 2;
>> +     return APIC_INTEGRATED(ver) ? GET_APIC_MAXLVT(ver) : 2;
>                                                      ^^^
> Hi, is this correct?
> Does ver have the full content of apic_read(APIC_LVR)?


good catch..

YH
