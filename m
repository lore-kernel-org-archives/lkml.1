Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbYGYOBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbYGYOBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYGYOBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:01:05 -0400
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:1037 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854AbYGYOBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:01:05 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=EiEmuJc4EOpH5SAu0gIhBW3ZbC1TdxTo84RG7wkLXt9MiC8KYMeQs7LO
   kKjmfrBu7vs54MymCyDsMCs5qKmPeIaGYgtiBYsalMOn/Y1+Olp2br/zA
   /7H/lCnjhX08Dt1;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.31,252,1215381600"; 
   d="scan'208";a="23570009"
X-IronPort-AV: E=Sophos;i="4.31,252,1215381600"; 
   d="scan'208";a="32952246"
Message-ID: <4889DCA4.4010800@fujitsu-siemens.com>
Date: Fri, 25 Jul 2008 16:01:08 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take
 3)
References: <20080724120512.GA21804@lenovo> <488889B6.9070707@fujitsu-siemens.com> <20080724143151.GA32422@lenovo> <20080724150116.GC32422@lenovo> <48889C14.4070408@fujitsu-siemens.com> <4889968E.6020000@fujitsu-siemens.com> <20080725100844.GA16698@lenovo> <4889C723.7050402@fujitsu-siemens.com> <20080725125950.GA28466@lenovo> <4889D767.5050709@fujitsu-siemens.com> <20080725134831.GB28466@lenovo>
In-Reply-To: <20080725134831.GB28466@lenovo>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:

> Martin, if I understood you right - this means your patch is not
> needed? 

The patch would still be needed. Just the reported failure of my 
simplified patch on the old kernel would not have occurred in the 
current kernel. IOW, the patch is fine for the current kernel, but not 
for the old one.

> Actually on 64bit mode APIC_DIVISOR is a bit hidden in
> __setup_APIC_LVTT - you may see it as APIC_TDR_DIV_16 while setting
> up divisor register. I was proposing patch for that but it leaded
> to potetntial overflow (thanks Ingo for catching) so we leave it as
> is. Maybe I miss something?

The problem was not that the divisor 16 was used for the counter speed 
(APIC_TDR_DIV_16), but that the old code set the counter start value to 
(250000000/16) rather than just 250000000. That means the counter will 
underflow earlier.

I am attaching a "take 3" patch which minimizes the risk of an underflow 
by using the maximum possible initial value for the APIC timer.

Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DEV 6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 8 15113
Fax:			++49 5251 8 20209
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
