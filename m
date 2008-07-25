Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbYGYQcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbYGYQcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYGYQcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:32:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:56549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbYGYQci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:32:38 -0400
Date: Fri, 25 Jul 2008 18:51:56 +0200
From: Olaf Dabrunz <od@suse.de>
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take 2)
Message-ID: <20080725165156.GA30196@suse.de>
Mail-Followup-To: Martin Wilck <martin.wilck@fujitsu-siemens.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
	"Maciej W. Rozycki" <macro@linux-mips.org>
References: <48885DDC.9010003@fujitsu-siemens.com> <20080724111631.GA3432@lenovo> <48886E6D.1030005@fujitsu-siemens.com> <20080724120512.GA21804@lenovo> <488889B6.9070707@fujitsu-siemens.com> <20080724143151.GA32422@lenovo> <20080724150116.GC32422@lenovo> <48889C14.4070408@fujitsu-siemens.com> <4889968E.6020000@fujitsu-siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4889968E.6020000@fujitsu-siemens.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-Jul-08, Martin Wilck wrote:
> I wrote:
>
>> This patch fixes this by two separate measures:
>>   a) make sure that no significant interruption occurs between APIC and
>>      TSC reads
>>   b) make sure that the measurement loop isn't significantly longer
>>      than originally intended.
>
> Here is a new, simplified version of our patch that only uses measure a).
> We verified that this is sufficient for accurate calibration.
>
> If we fail to determine the start or end time of the calibration correctly 
> 10 times in a row, we will print a critical error message and go on. One 
> might as well argue that this should cause a kernel panic (it is impossible 
> to run on the CPU for only a few cycles without being interrupted by an 
> SMI!), but Cyrill probably won't agree.

Note that the SMIs may be triggered when the APIC is read. This may
change after the first (or the first few) SMIs have been triggered. So
the "too many SMIs" case during the calibration does not necessarily
mean that the system can not run normally after the calibration is done.

This is why I would prefer the solution with the error message.

Regards,

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

