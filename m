Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbXLCRP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbXLCRP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXLCRPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:15:18 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:58561 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750866AbXLCRPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:15:17 -0500
Message-ID: <475439A7.6060108@cfl.rr.com>
Date: Mon, 03 Dec 2007 12:15:19 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       noah <noah123@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Possibly SATA related freeze killed networking and RAID
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com> <20071120220512.46b9e975@the-village.bc.nu> <20071126120649.GC4701@ucw.cz> <474CCA82.7030000@gmail.com> <474F3A4B.3080304@cfl.rr.com> <474F530D.8090302@gmail.com> <47505A63.8070507@cfl.rr.com> <4750A33C.4080509@gmail.com>
In-Reply-To: <4750A33C.4080509@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Dec 2007 17:15:48.0870 (UTC) FILETIME=[2618FA60:01C835D0]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15584.000
X-TM-AS-Result: No--6.241400-5.000000-2
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Surprise, surprise.  There's no way to tell whether the controller
> raised interrupt or not if command is not in progress.  As I said
> before, there's no IRQ pending bit.  While processing commands, you can
> tell by looking at other status registers but when there's nothing in
> flight and the controller determines it's a good time to raise a
> spurious interrupt, there's no way you can tell.  That dang SFF
> interface is like 15+ years old.
> 
> But we can still make things pretty robust.  We're working on it.
> 
> Thanks.
> 

It sounds like you mean that you know the controller did NOT raise the 
interrupt ( intentionally/correctly ) if there was no command in 
progress, as opposed to not being able to tell.  Unless there is some 
condition under which it is valid for the controller to raise an 
interrupt when it had no commands in progress?  And if that's the case 
and there's know way to know WHY, that's a broken design.

