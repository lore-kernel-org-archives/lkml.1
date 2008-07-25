Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYGYNkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYGYNkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 09:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYGYNk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 09:40:28 -0400
Received: from dgate20.fujitsu-siemens.com ([80.70.172.51]:35015 "EHLO
	dgate20.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbYGYNk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 09:40:28 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=aXPKCZN8dY5uXpIdAMlTzK/YWrslA8Im6wTicv09QZItByYEJXwb3Tjs
   gnPLXEUwrO7bWhd7XuWpkgvRcdn7VBTHm17vrO2/N9ZcfDs31bvtVPioq
   xnHRapFOmXvtn+A;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.31,252,1215381600"; 
   d="scan'208";a="21222489"
X-IronPort-AV: E=Sophos;i="4.31,252,1215381600"; 
   d="scan'208";a="36376271"
Message-ID: <4889D767.5050709@fujitsu-siemens.com>
Date: Fri, 25 Jul 2008 15:38:47 +0200
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
 2)
References: <20080724111631.GA3432@lenovo> <48886E6D.1030005@fujitsu-siemens.com> <20080724120512.GA21804@lenovo> <488889B6.9070707@fujitsu-siemens.com> <20080724143151.GA32422@lenovo> <20080724150116.GC32422@lenovo> <48889C14.4070408@fujitsu-siemens.com> <4889968E.6020000@fujitsu-siemens.com> <20080725100844.GA16698@lenovo> <4889C723.7050402@fujitsu-siemens.com> <20080725125950.GA28466@lenovo>
In-Reply-To: <20080725125950.GA28466@lenovo>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:

> I have to say that my simplified patch failed to do the calibration
> correctly on our test system (the original patch worked well). Please
> stay tuned, we are investigating this currently.

Please forget that. It was observed on an old "enterprise" kernel with 
which we are currently testing the backported patch with, and it was due 
to the fact that the initial counter value on that kernel was divided by 
APIC_DIVISOR (=16). The resulting initial counter value was too low in a 
"SMI flood" case, the counter could overlap. APIC_DIVISOR is no longer 
used in the current kernel.

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
