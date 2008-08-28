Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbYH1UTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbYH1UTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYH1UTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:19:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:15674 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbYH1UTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:19:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=x7odSB42qjcbn0Abk41zA6deNMkGAcfGqiAbCP5yssdEzUq2E5Hbpi7QsIWaAVhIKM
         ZoFHvOzEwSmjuEWQVCgKQl8cKdXm8DabrlEwduKKr2NtbmUxiX4lcTENjzrKg2R4Euz8
         +M/P3XpjaT0iYA52XkQMjUFPD+FETDtd0s+HQ=
Message-ID: <86802c440808281319i2f727274g505e43a2f6f6cdeb@mail.gmail.com>
Date: Thu, 28 Aug 2008 13:19:30 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0808281255200.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219952345-13574-1-git-send-email-yhlu.kernel@gmail.com>
	 <alpine.LFD.1.10.0808281255200.3300@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 1:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 28 Aug 2008, Yinghai Lu wrote:
>>
>> so could let BAR res register at first, or even pnp?
>
> Well, I'm not sure whether PnP or e820 should be first, as long as any
> "real hardware" probing takes precedence over either. I _suspect_ that
> e820 is more trustworthy, which implies that PnP should probably be added
> last. It would be good to have some idea what Windows does, since usually
> all the firmware bugs are essentially hidden by whatever that other OS
> happens to do.
>
> The basic rule really should be: "What do we trust most?" and probe things
> in that order.
>
> So e820 is fairly trustworthy, but we know that it will have various
> random things marked as reserved because they are special in some way (but
> we don't know _how_ they are special - they may well be real BAR's that
> just have a fixed meaning to ACPI or whatever).
>
> But we obviously trust _part_ of it (the RAM stuff) more than we trust
> other parts. So it does make sense to consider that separately.
>
> PnP I personally wouldn't trust at all, except as a way to keep dynamic
> resources away from those things, which is why I'd put it last. But that's
> just my personal gut feeling.
>
> Hardware we generally trust more than any firmware, but even hardware can
> have bugs. And some classes of hardware tends to be less buggy than others
> (ie I'd trust some on-die APIC base pointer before I would trust a Cardbus
> controller BAR, for example).

ok, will move e820_reserve_resource_late to pcibios_resource_survey(),
so it is called vi pci_subsys_init before pnp_system_init

YH
