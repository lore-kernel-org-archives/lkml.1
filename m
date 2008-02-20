Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYBTWAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYBTWAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760790AbYBTWAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:00:30 -0500
Received: from gw.goop.org ([64.81.55.164]:44397 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760500AbYBTWA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:00:27 -0500
Message-ID: <47BCA275.7000504@goop.org>
Date: Wed, 20 Feb 2008 13:58:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Joel Becker <Joel.Becker@oracle.com>,
       Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>	 <20080215202336.GE26034@mail.oracle.com>	 <1203274161.27987.6.camel@localhost.localdomain>	 <20080218104025.GA15899@ca-server1.us.oracle.com>	 <1203458366.26910.15.camel@cthulhu.hellion.org.uk>	 <47BBDA20.8030105@zytor.com> <1203497511.26910.39.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1203497511.26910.39.camel@cthulhu.hellion.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Tue, 2008-02-19 at 23:43 -0800, H. Peter Anvin wrote:
>   
>> Ian Campbell wrote:
>>     
>>> On Mon, 2008-02-18 at 02:40 -0800, Joel Becker wrote:
>>>       
>>>> On Sun, Feb 17, 2008 at 06:49:21PM +0000, Ian Campbell wrote:
>>>>         
>>>>> x86/xen: Do not scan for DMI unless the DMI region is reserved by e820.
>>>>>           
>>>> 	This fixed it.  I'm now booting successfully.  Thank you!
>>>>         
>>> Excellent. Jeremy, are you happy for this to go in?
>>>       

I had no problem with it, but Peter's objection seems substantial enough.

> As far as the actual change goes I was assuming that any machine that
> has DMI/SMBIOS would easily be new enough to have an E820 which could be
> expected to reserve this region. Looks like I was mistaken about how
> long E820 had been around and/or how reliably it is used to reserve the
> tables.
>
> Anyway, will have to think of another solution.
>   

Well, the way we've handled this kind of thing elsewhere is to just 
reserve that pseudophys address space in earlish Xen init code and fill 
it with not-DMI things (zero, I guess).  It's a bit of a waste of 
memory, but maybe we can recover it once DMI has given up and gone 
away.  This also makes it easy to insert faked-up DMI info if that turns 
out to be useful.


    J
