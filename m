Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbYGSXLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbYGSXLr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 19:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYGSXLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 19:11:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:36039 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbYGSXLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 19:11:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=baae+eaaW5HYpLqGe/56REm1JS+3uHY/uDuh1ehAPhUcomJsHhPLOYWz3C+uye7MIr
         rT8wm0W6qpQrtXV+WmQ/Qfy8od9/nfl04LzsfrPRwehYEmOPYHnn6vuw35uhNqt5G3Nj
         df8wShq3aSAYKaipyK9ABXfjEJSK2TLicEUJc=
Message-ID: <19f34abd0807191611y7cabf405iad307ba79591e04f@mail.gmail.com>
Date: Sun, 20 Jul 2008 01:11:36 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068 trace_hardirqs_on_caller
Cc: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Dave Hansen" <haveblue@us.ibm.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       kernel-testers@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Bernhard Walle" <bwalle@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Vivek Goyal" <vgoyal@redhat.com>
In-Reply-To: <20080719225817.GA6264@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080718195352.e562a00f.sfr@canb.auug.org.au>
	 <200807190928.33978.m.kozlowski@tuxland.pl>
	 <19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com>
	 <19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com>
	 <20080719221723.GB5578@suse.de>
	 <19f34abd0807191527u61c5ed61kffe2279c8d46915d@mail.gmail.com>
	 <19f34abd0807191544nfd73be5nf7dde4b61992a7e8@mail.gmail.com>
	 <20080719225817.GA6264@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 12:58 AM, Greg KH <gregkh@suse.de> wrote:
>> firmware_map_add_early() is using bootmem for the allocation. So yes,
>> I guess it should possible to use kobjects here. That said, this code
>> is in fact fairly recent:
>>
>> commit 69ac9cd629ca96e59f34eb4ccd12d00b2c8276a7
>> Author: Bernhard Walle <bwalle@suse.de>
>> Date:   Fri Jun 27 13:12:54 2008 +0200
>>
>>     sysfs: add /sys/firmware/memmap
>>
>> I'll add the Cc. I still have a feeling that the kobject patch should
>> expect to run even when slab is not available.
>
> I never has been expected to do so in the past, so odds are, lots of
> things might break :(

Yeah. Maybe you should withdraw your ack? :-D

    Signed-off-by: Bernhard Walle <bwalle@suse.de>
    Acked-by: Greg KH <gregkh@suse.de>
    Acked-by: Vivek Goyal <vgoyal@redhat.com>
    Cc: kexec@lists.infradead.org
    Cc: yhlu.kernel@gmail.com
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

I'm sorry for having been a bit rash earlier -- it's the combination
of the patches that produce the failure; they both seem okay on their
own. On the other hand, this is what -next is for, isn't it?

Maybe the firmware memmap code can simply run a little later in the
boot sequence?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
