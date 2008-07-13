Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYGMUVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYGMUVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 16:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYGMUVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 16:21:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34312 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbYGMUVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 16:21:41 -0400
Message-ID: <487A63D2.9040006@firstfloor.org>
Date: Sun, 13 Jul 2008 22:21:38 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Lutomirski <luto@myrealbox.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <200807122253.32382.rjw@sisk.pl> <48793A0E.3050803@myrealbox.com> <200807130133.12324.rjw@sisk.pl> <20080713091524.GA29907@elte.hu> <20080713120253.GA27582@srcf.ucam.org> <487A2431.2050103@myrealbox.com> <487A4CB7.1080001@firstfloor.org> <487A62B3.8010207@zytor.com>
In-Reply-To: <487A62B3.8010207@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Andi Kleen wrote:
>>
>> Hmm, but the change was not supposed to break the s3 bios. Something
>> fishy is going on. It sounds like the s3 bios relies on some earlier
>> segment register setup.
>>
>> If true this means the segment register reset would need to be moved
>> later after S3 bios ran. Saving/restoring is unfortunately not possible
>> because we cannot save/restore the hidden state loaded from the GDT
>> earlier.
>>
> 
> That really doesn't make sense, though.  The VESA BIOS has to be entered
> in clean real mode; it's designed to be entered from reset, after all.
> There is definitely something fishy going on, but I don't think this
> particular aspect is it.

It probably switches to protected mode. I noticed this on my old
Fujitsu laptop when I tried to make the S3 wakeup run in the s2ram x86 emulator
and found it entered protected mode at some point, which x86emu
didn't support.

I guess Lenovo is doing the same.

And that protected mode code relies on some GDT values that have been
loaded earlier when the BIOS also went into protected mode.

It seems the BIOS programmers really don't like real mode anymore.
Somehow understandable.

-Andi
