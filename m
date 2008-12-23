Return-Path: <linux-kernel-owner+w=401wt.eu-S1752013AbYLWTmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbYLWTmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 14:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYLWTmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 14:42:46 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:7896 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYLWTmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 14:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rQmlJjPDJThH1X9rvEw7s+pO5t+B0x/2YQhBBLiay+VS1TwQYNo7rwZ8L9kY/oFU6s
         HtP2KAYvLCqPI9K0XexEE6o5Ky7cm5ZYYPNX+wBMOLbsUuZkPQqKJYWsM7w+zu0WQ7No
         nFl8dwvMNh9OdOs2/JLCIczIVNgWOVmNe55IM=
Message-ID: <b637ec0b0812231142q5437c1bevde4cb6e00f9bcc71@mail.gmail.com>
Date: Tue, 23 Dec 2008 20:42:39 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: TSC not updating after resume: Bug or Feature?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <srostedt@redhat.com>, dsaxena@plexity.net,
       LKML <linux-kernel@vger.kernel.org>,
       "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>, toralf.foerster@gmx.de
In-Reply-To: <alpine.LFD.2.00.0812222332400.3723@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net>
	 <alpine.LFD.2.00.0812222056190.3723@localhost.localdomain>
	 <b637ec0b0812221239p169967aemf14b2e591779f5cd@mail.gmail.com>
	 <alpine.LFD.2.00.0812222212191.3723@localhost.localdomain>
	 <b637ec0b0812221335w54fe11ecwf05e0302bc27b5a3@mail.gmail.com>
	 <alpine.LFD.2.00.0812222238192.3723@localhost.localdomain>
	 <b637ec0b0812221412w396337embad90f599a02d3d9@mail.gmail.com>
	 <alpine.LFD.2.00.0812222315460.3723@localhost.localdomain>
	 <b637ec0b0812221429m441b9493q97a7ccb82dfc0334@mail.gmail.com>
	 <alpine.LFD.2.00.0812222332400.3723@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas.
Everything seems to work fine after further testing.
Regards,
Fabio




On Mon, Dec 22, 2008 at 11:33 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Fabio,
>
> On Mon, 22 Dec 2008, Fabio Comolli wrote:
>
>> OK, it seems that you got it.
>>
>> The system survived two hibernation / resume cycles without triggering
>> the warning and, probably the most important part, the dmesg does not
>> have any "jumps" before the "Force enable HPET on resume" line as
>> before:
>>
>> [  275.647704] PM: Creating hibernation image:
>> [  275.648005] PM: Need to copy 177844 pages
>> [  275.648005] Intel machine check architecture supported.
>> [  275.648005] Intel machine check reporting enabled on CPU#0.
>> [  275.648005] Force enabled HPET at resume
>> [  275.648005] ACPI: Waking up from system sleep state S4
>> [  275.669038] ACPI: EC: non-query interrupt received, switching to
>> interrupt mode
>> [  275.740697] pcieport-driver 0000:00:01.0: setting latency timer to 64
>> [  275.740781] pcieport-driver 0000:00:1c.0: setting latency timer to 64
>> [  275.740786] pciehp 0000:00:1c.0:pcie02: pciehp_resume ENTRY
>>
>> ...and so on.
>>
>> As i mentioned in the bug report, to be sure that the bug doesn't
>> trigger I have to wait at least on day and > 10 hibernation / resumee
>> cycles.
>
> Sure.
>
>> But with your first patch the bug triggered at the second cycle, so
>> I'm optimist :-)
>>
>> I'll keep you informed. Many thanks in advance,
>
> Many thanks to you for following up on this.
>
>     tglx
>
