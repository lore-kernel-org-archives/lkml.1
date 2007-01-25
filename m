Return-Path: <linux-kernel-owner+w=401wt.eu-S1030500AbXAYX07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030500AbXAYX07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 18:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030501AbXAYX07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 18:26:59 -0500
Received: from smtp.bulldogdsl.com ([212.158.248.8]:2488 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030500AbXAYX06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 18:26:58 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 2.6.18-stable release plans?
Date: Thu, 25 Jan 2007 23:26:50 +0000
User-Agent: KMail/1.9.5
Cc: Ken Moffat <zarniwhoop@ntlworld.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
References: <486377.64357.qm@web52903.mail.yahoo.com>
In-Reply-To: <486377.64357.qm@web52903.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701252326.50719.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 January 2007 09:16, Chris Rankin wrote:
> But anyway - can someone please tell me what "Eeek! page_mapcount(page)
> went negative! (-1)" is *really* saying/implying? Because I am currently
> translating this as "I WANT TO EAT YOUR FILESYSTEMS".

Hugh already did, multiple times. If there's an external hardware event that 
corrupts memory, code executing on your CPU is no longer going to behave 
deterministically. So cases that are typically "impossible" in the design of 
the code have a chance to trigger.

You can continue to flame 2.6.19, but you're an extreme minority when it comes 
to this kind of bug and as, again, Hugh already said, almost all of the 
reports of this and similar other bugs have led to hardware problems that 
were either unchecked or difficult to detect.

Imagine this scenario. It might seem unrealistic to you, but it's not 
impossible!

First Use of Linux -> Upgrading to 2.6.19
	Undetected hardware error never triggered.

Running 2.6.19
	Hardware error triggers. Linux crashes.

Going back to 2.6.18
	Hardware error has not yet triggered again.

Will it eat your filesystem? Maybe. But it probably won't, if you claim the 
memory is tested, it could have been a single bit error, or a cosmic ray 
event, or a brownout, or anything similar. It's much more likely to simply 
crash your machine, as it did.

Not running the affected kernel again is a sure way to have _nobody_ listen to 
your complaints about 2.6.19 having a real software bug, because you're 
totally unwilling to test the kernel again and see if it triggers. A single 
report is simply not enough evidence. 

Additionally, reports from other users (who may have a million different 
experimental variables involved) are also insufficient, for reasons which 
have already been explained (drivers, proprietary code, et cetera).

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
