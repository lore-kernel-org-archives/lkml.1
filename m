Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbYGXPNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbYGXPNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYGXPNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:13:24 -0400
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:35190 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757553AbYGXPNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:13:23 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=NAimO3Wj7geGscrQgCbd0V438Dm4FXXWiIByyd5nI+POEQyEUlevyO0w
   VxlaoH0ZC0US1Og7XVH6/tU7dtsCGODI0aLrvQsW2tx0dSoXny5gpZjlr
   KVOZwzsvbaQdN5F;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.31,246,1215381600"; 
   d="scan'208";a="23425126"
X-IronPort-AV: E=Sophos;i="4.31,245,1215381600"; 
   d="scan'208";a="36323316"
Message-ID: <48889C14.4070408@fujitsu-siemens.com>
Date: Thu, 24 Jul 2008 17:13:24 +0200
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
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe
References: <48885DDC.9010003@fujitsu-siemens.com> <20080724111631.GA3432@lenovo> <48886E6D.1030005@fujitsu-siemens.com> <20080724120512.GA21804@lenovo> <488889B6.9070707@fujitsu-siemens.com> <20080724143151.GA32422@lenovo> <20080724150116.GC32422@lenovo>
In-Reply-To: <20080724150116.GC32422@lenovo>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

 > btw, Martin, don't get me wrong please - i'm not just complaining :)
 > The changes you propose is important enough _but_ it could introduce
 > regression. Look, with situation of miscalibrated apic timer kernel
 > was working before but with the patch it could stop to work. So if
 > user has a such screwed motherboard he could be shocked if it stop
 > booting with message about SMI happened. we defenitely have to provide
 > some workaround for this. And your max iteration counter solution
 > would be fine I think.

Let's see what other people think about this. I am fine with both 
solutions. Currently only the first one has been tested though (testing 
these patches thoroughly needs long-time reboot tests).

One more remark: There are similar calibration routines around in the 
kernel which suffer from similar problems as calibrate_APIC_clock(). 
AFAIK, only calibrate_delay() was made SMI-safe by Venkatesh Pallipadi 
years ago.

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
