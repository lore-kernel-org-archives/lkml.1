Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbYAUKZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbYAUKZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761610AbYAUKJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:09:22 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:21477
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761001AbYAUKJT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:09:19 -0500
Message-Id: <47947D7E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 21 Jan 2008 10:09:50 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Greg KH" <greg@kroah.com>
Cc: "Greg Kroah-Hartman" <GregKH@novell.com>,
       "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] introduce __devinitconst
References: <47873D110200007800068158@novell.com>
 <47873D87.76E4.0078.0@novell.com> <20080119012807.GB6150@kroah.com>
In-Reply-To: <20080119012807.GB6150@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Greg KH <greg@kroah.com> 19.01.08 02:28 >>>
>On Fri, Jan 11, 2008 at 01:57:27AM -0700, Jan Beulich wrote:
>> The drivers picked just serve as examples (which I routinely build and
>> hence am able to easily verify), i.e. as before he patch doesn't change
>> all instances where 'const' could have been added as a result of the
>> base change, only where the change has a real effect (the module loader
>> doesn't enforce read-only section attributes at present, so only
>> built-in files make a real difference).
>
>What does this buy us?

Not sure what part the question applies to...

>> --- 2.6.24-rc7-initconst.orig/include/linux/init.h
>> +++ 2.6.24-rc7-initconst/include/linux/init.h
>> @@ -257,11 +257,13 @@ void __init parse_early_param(void);
>>  #ifdef CONFIG_HOTPLUG
>>  #define __devinit
>>  #define __devinitdata
>> +#define __devinitconst const
>>  #define __devexit
>>  #define __devexitdata
>>  #else
>>  #define __devinit __init
>>  #define __devinitdata __initdata
>> +#define __devinitconst __initdata
>
>Shoudn't that be "__initdata const" or something like that?

No, specifically not, as otherwise this will report in 'section type conflict'
compiler (or assembler?) warnings.

But Sam's concept addresses this in a neater way anyway, so my current
take is that I'll resubmit any parts needed after he's got his patch in.

Jan

