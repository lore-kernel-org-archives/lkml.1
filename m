Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbXLDBc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbXLDBc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 20:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXLDBcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 20:32:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:13514 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbXLDBcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 20:32:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Oc6pZYP9ONUCL6h0CQgxH/f2lUKq4nFqeTPtDfoKsTuV7mI+mgxfeYyosrciIPtgo1wJGgodzu9itA9t2VMGlceNtL7SQcrkaD5kH8Rhr7SyZ5E323keaBgndXEYkqqbXu/P94ByXFqEOINBrgyi2kmtGSEZQ0MknGEEHWouGoU=
Message-ID: <4754AE37.9050403@gmail.com>
Date: Tue, 04 Dec 2007 10:32:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       noah <noah123@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Possibly SATA related freeze killed networking and RAID
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com> <20071120220512.46b9e975@the-village.bc.nu> <20071126120649.GC4701@ucw.cz> <474CCA82.7030000@gmail.com> <474F3A4B.3080304@cfl.rr.com> <474F530D.8090302@gmail.com> <47505A63.8070507@cfl.rr.com> <4750A33C.4080509@gmail.com> <475439A7.6060108@cfl.rr.com>
In-Reply-To: <475439A7.6060108@cfl.rr.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Tejun Heo wrote:
>> Surprise, surprise.  There's no way to tell whether the controller
>> raised interrupt or not if command is not in progress.  As I said
>> before, there's no IRQ pending bit.  While processing commands, you can
>> tell by looking at other status registers but when there's nothing in
>> flight and the controller determines it's a good time to raise a
>> spurious interrupt, there's no way you can tell.  That dang SFF
>> interface is like 15+ years old.
>>
>> But we can still make things pretty robust.  We're working on it.
> 
> It sounds like you mean that you know the controller did NOT raise the
> interrupt ( intentionally/correctly ) if there was no command in
> progress, as opposed to not being able to tell.  Unless there is some
> condition under which it is valid for the controller to raise an
> interrupt when it had no commands in progress?  And if that's the case
> and there's know way to know WHY, that's a broken design.

If everything works correctly, all interrupts can be accounted for.
It's just that there's no margin for erratic behaviors and most ATA
controllers are built really cheap.  So, yeah, it's a 15+ years old
half-broken design.

-- 
tejun
