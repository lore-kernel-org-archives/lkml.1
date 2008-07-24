Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYGXNmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYGXNmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYGXNmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:42:31 -0400
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:48131 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643AbYGXNmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:42:31 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=OUUv0gjUjnUSz3kVuV3gmVosjrHQpk4IqeYokC+PMZIYfLx1gDzbBqGI
   pMK4SSUp4HBsGwNFAZFmROi9QbUhtyrvwaZAiivXOEzKMfoijcznW2OzU
   FbhYGTABP7JLGNy;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.31,245,1215381600"; 
   d="scan'208";a="23408036"
X-IronPort-AV: E=Sophos;i="4.31,245,1215381600"; 
   d="scan'208";a="36319246"
Message-ID: <488886C8.3020904@fujitsu-siemens.com>
Date: Thu, 24 Jul 2008 15:42:32 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe
References: <48885DDC.9010003@fujitsu-siemens.com> <48888444.1020305@zytor.com>
In-Reply-To: <48888444.1020305@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:

> The other thing we may want to consider is doing multiple runs of the
> calibration loop.  I suspect we'd get a more accurate result running,
> say, 9 loops of the 1/9 the current duration and looking either for the
> best result or the median (NOT the mean.)
> 
>         -hpa

We considered that. However I think if you know what result to expect 
(here: TICK_COUNT + a few cycles) it is both easier and safer to compare 
against the expected value than to do statistics. SMI protection is all 
about outliers (thus, the median is a good suggestion but I'd say it 
would be over-enigineered).

Martin

PS: I am sorry for the stupid, misleading typo (SMi -> smp) in the mail 
subject.

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
