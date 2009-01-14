Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZANTdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZANTdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbZANTcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:32:54 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:1615 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbZANTcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:32:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Safnuj5rn07MdU77mWvPT0AX0xDzD7+7JcmZF8/65ZfwHhehDgEQFvyAnCd1HI9THq
         zREJUZS9DyJPfEexKGSvKYAYHGU0YCNGbbTy1aj8wvSAO8MrQutqLObX7qomDSC5eceO
         p51WkcnKJPGFFmFQToP412IaXeaTN7bmeLDKQ=
MIME-Version: 1.0
In-Reply-To: <496E297B.6010100@linux.intel.com>
References: <20081227155019.GA15493@elte.hu> <20081227225102.GA17822@elte.hu>
	 <49594411.60000@linux.intel.com> <20090113174522.GA26965@elte.hu>
	 <b3ece790901131057w4c76a428p4308b494675d69aa@mail.gmail.com>
	 <496DB067.6060402@linux.intel.com>
	 <b3ece790901140818i183bc30n2de01b5edaa6a2c7@mail.gmail.com>
	 <496E297B.6010100@linux.intel.com>
Date: Wed, 14 Jan 2009 11:32:51 -0800
Message-ID: <b3ece790901141132u28ba2482h2e7af7bd51224f2a@mail.gmail.com>
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
From: Tim Hockin <thockin@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       ying.huang@intel.com, Aaron Durbin <adurbin@gmail.com>,
       priyankag@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 10:05 AM, Andi Kleen <ak@linux.intel.com> wrote:
>
>>
>> From my point of view: a single, consistent, easy logging interface
>> for the kernel to send *structured data* about hardware/system events
>> and errors up to userspace.
>
> Which kinds of events were you thinking of?
>
> So far we managed by cramming some other CPU events like thermal
> trip into "pseudo banks" in struct mce. Admittedly it's not the
> most pretty solution in the world, but it worked.

Yeah, no offense, but that's horrible :)

Ideally, I'd rather see a more generic conduit for all sorts of
events.  Polled and exception MCEs.  Thermal interrupts.  MCE
threshold interrupts.  EDAC polled errors.  PCI-express errors.  SATA
disk timeouts.

Now I know there are different conduits for some events - netlink
tells me about netif link up/down events I think.  I would settle for
a small number of interfaces.  What I don't want is what we have today
- EVERYTHING has a different interface.  Some are poll()-able.  Some
have to be actively polled.  Some have to have a daemon listening or
else messages are dropped.  Some have to parse logs.  Puke.

Put it this way:  Given a thousand machines, I want to gather,
collate, and correlate all these events.  I want to be able to produce
a "life story" of sorts for a machine and for a data center.  Once I
can do that, I can start to make predictive diagnoses more accurately,
and I can know how much these things actually COST us.

Tim
