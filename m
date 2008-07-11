Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYGKJBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYGKJBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYGKJBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:01:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:18281 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbYGKJB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nI4SRVNbp2Xd3u1XETy3vjZk4JvGivlTTaHyabpYb/9K3iBe0VC7CYtu2j2zVo93Jz
         uKNYSmyV7vawU7vy1wXUXDBjLt2sUQo36utEYugJ/wLtpOzAfBvh2IPVRpFCS2FIRY4F
         gXg6Jtmh+9nRVkByo3LbCY5nsq9TGN3+yNP3Q=
Message-ID: <86802c440807110201u4ece646aw4d67a2630d653b33@mail.gmail.com>
Date: Fri, 11 Jul 2008 02:01:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [x86, patch] turn x86 VISWS into a generic architecture
Cc: "Robert Richter" <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>
In-Reply-To: <20080711085407.GB20987@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710170712.GA14583@elte.hu>
	 <20080711083946.GU7963@erda.amd.com> <20080711085407.GB20987@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 1:54 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Robert Richter <robert.richter@amd.com> wrote:
>
>> On 10.07.08 19:07:12, Ingo Molnar wrote:
>>
>> [...]
>>
>> > diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
>> > index 99d9f09..e515e8d 100644
>> > --- a/arch/x86/pci/Makefile
>> > +++ b/arch/x86/pci/Makefile
>> > @@ -9,9 +9,7 @@ pci-y                               := fixup.o
>> >  pci-$(CONFIG_ACPI)         += acpi.o
>> >  pci-y                              += legacy.o irq.o
>> >
>> > -# Careful: VISWS overrule the pci-y above. The colons are
>> > -# therefor correct. This needs a proper fix by distangling the code.
>> > -pci-$(CONFIG_X86_VISWS)            := visws.o fixup.o
>> > +pci-$(CONFIG_X86_VISWS)            += visws.o
>>
>> Ingo, if we turn this into generic code, we have to remove the
>> subsys_initcall for this too. Otherwise subsystem initialization is
>> running twice, in legacy.c and in visws.c.
>
> Ok. Mind sending a patch for this against tip/master? Both your changes
> and the visws cleanups are all in there and are tested through on
> typical hardware.
>
> (Also, there's the suggestion from Yinghai to first do the numa init.)

could change the numa.c to numaq.c too. that name is confusing..

YH
