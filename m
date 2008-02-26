Return-Path: <linux-kernel-owner+w=401wt.eu-S1764513AbYBZUJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764513AbYBZUJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYBZUI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:08:58 -0500
Received: from gw.goop.org ([64.81.55.164]:52500 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbYBZUI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:08:57 -0500
Message-ID: <47C47107.2020608@goop.org>
Date: Tue, 26 Feb 2008 12:05:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Joel Becker <Joel.Becker@oracle.com>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>	 <20080215202336.GE26034@mail.oracle.com>	 <1203274161.27987.6.camel@localhost.localdomain>	 <20080218104025.GA15899@ca-server1.us.oracle.com>	 <1203458366.26910.15.camel@cthulhu.hellion.org.uk>	 <47BBDA20.8030105@zytor.com>	 <1203497511.26910.39.camel@cthulhu.hellion.org.uk>	 <47BCA275.7000504@goop.org>	 <1203546597.26910.74.camel@cthulhu.hellion.org.uk>	 <47BDEA11.6010302@goop.org> <47BDEB57.5040203@zytor.com>	 <47BDEF36.8000903@goop.org>	 <1203631956.28436.4.camel@cthulhu.hellion.org.uk>	 <47BDF9C7.6040400@zytor.com> <47BE0017.1020205@goop.org>	 <47BE0228.7020204@zytor.com>	 <1203665106.28436.19.camel@cthulhu.hellion.org.uk> <1204045592.12238.6.camel@muff>
In-Reply-To: <1204045592.12238.6.camel@muff>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
>> @@ -371,6 +372,9 @@ void __init dmi_scan_machine(void)
>>  		}
>>  	}
>>  	else {
>> +		if (e820_all_mapped(0xF0000, 0xF0000+0x10000, E820_RAM))
>> +			goto out;
>>     
>
> 	One issue with using the e820 map for this is that a Xen Dom0 will also
> have this region marked as RAM in the e820 map, but will set up a fixmap
> for it, allowing dmi_scan_machine() to map the region.
>   

Would it be easier to just fake up a mapping so that window points to 
the real dmi area, and mark E820 accordingly?

    J
