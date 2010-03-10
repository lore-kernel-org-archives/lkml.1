Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab0CJJ6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:58:51 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:40831 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932074Ab0CJJ6r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:58:47 -0500
X-Greylist: delayed 806 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 04:58:47 EST
From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
To: Sachin Sant <sachinp@in.ibm.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>
Date: Wed, 10 Mar 2010 15:15:12 +0530
Subject: RE: [-next Feb 9] Boot failure on x86_64: mptbase fails to
 initialize
Thread-Topic: [-next Feb 9] Boot failure on x86_64: mptbase fails to
 initialize
Thread-Index: AcqphYEwd2/QX7M7QTW0U6X0SNb35wWrfHzA
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249020E1A7BF0@inbmail02.lsi.com>
References: <20100209190736.fe252102.sfr@canb.auug.org.au>
 <4B715809.6000202@in.ibm.com>
In-Reply-To: <4B715809.6000202@in.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin,

This may be related to something specific to your system's APIC/or bad HW rather than pure driver issue.
Below line from log is important to note.
"mptsas 0000:03:04.0: can't find IRQ for PCI INT A; probably buggy MP table"

It means LSI controller is not able to reserve IRQ line and that is where all problem starts.
Need to broaden the scope of the issue.

Another confusing thing to me.
I have seen "probably buggy MP table" print only in arch/x86, but you have mentioned that in your case arch is x86_64.

Thanks,
Kashyap




> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Sachin Sant
> Sent: Tuesday, February 09, 2010 6:12 PM
> To: linux-scsi
> Cc: linux-next@vger.kernel.org; LKML; Moore, Eric
> Subject: [-next Feb 9] Boot failure on x86_64: mptbase fails to
> initialize
> 
> Today's next failed to boot on my 4 way x86_64 box because of mptbase
> driver initialization failure.
> 
> Snippet of messages during boot :
> 
> Fusion MPT SAS Host driver 3.04.14
> mptsas 0000:03:04.0: can't find IRQ for PCI INT A; probably buggy MP
> table
> mptbase: ioc0: Initiating bringup
> ioc0: LSISAS1064 A3: Capabilities={Initiator}
> mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
> mptbase: ioc0: Initiating recovery
> mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x2,
> action 0
> mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
> mptbase: ioc0: Initiating recovery
> mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
> mptbase: ioc0: Initiating recovery
> mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x1,
> action 0
> mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
> 
> Eventually machine fails to boot. I have similar problem on a x86 box
> but with IPS driver. So might not be a driver specific issue.
> 
> I had similar problem with yesterday's next.IIRC the last successful
> boot was with next-20100203.
> 
> Have attached the boot log from x86_64 box.
> 
> Thanks
> -Sachin
> 
> 
> --
> 
> ---------------------------------
> Sachin Sant
> IBM Linux Technology Center
> India Systems and Technology Labs
> Bangalore, India
> ---------------------------------

