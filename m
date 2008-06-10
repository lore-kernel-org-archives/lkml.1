Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYFJTt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYFJTt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYFJTtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:49:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:36101 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYFJTtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dPy8Zey7ha0PtxrUJQgdzRCqiWPJr3osoWuOTZ9ku3sqv53m+Yh9mejUjP2K7QRXRz
         yWqr91xwhVXnGhumtM+VqvQ90H4A+EXsjBLWff2V3AdIfgQ1WOVF0I/Y93CseDbHOrIf
         5GzyWZnkoR+AZosYeazB3ffoanIQjAc18xf2M=
Message-ID: <86802c440806101249i3650aa59u1090110a803c3384@mail.gmail.com>
Date: Tue, 10 Jun 2008 12:49:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
In-Reply-To: <Pine.LNX.4.55.0806102025460.1702@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
	 <Pine.LNX.4.55.0806092058550.26593@cliff.in.clinika.pl>
	 <86802c440806091353m240ab7adocbaf5dacd15504f7@mail.gmail.com>
	 <Pine.LNX.4.55.0806092159350.26593@cliff.in.clinika.pl>
	 <Pine.LNX.4.55.0806100341520.31588@cliff.in.clinika.pl>
	 <86802c440806092208s338cf6b6q892f5149bbd142ca@mail.gmail.com>
	 <484E7B03.8000604@redhat.com>
	 <Pine.LNX.4.55.0806101418510.1702@cliff.in.clinika.pl>
	 <86802c440806101209q301bcef0ia859db7e587bd42e@mail.gmail.com>
	 <Pine.LNX.4.55.0806102025460.1702@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 12:36 PM, Maciej W. Rozycki
<macro@linux-mips.org> wrote:
> On Tue, 10 Jun 2008, Yinghai Lu wrote:
>
>> kernel should not assume io apic register is set right by firmware.
>
>  What is the basis of this assumption?  Linux generally assumes the
> chipset components have been placed by the firmware into a consistent
> state.  That does not necessarily mean suitable for Linux, hence the need
> to reconfigure a bit here or there, but there should be no need to touch
> components that are not going to be used by Linux directly.  The I/O APIC
> is no different.
>
>> and kernel actually doesn't trust them, and clear the io apic registers.
>
>  The I/O APIC registers are cleared, because this is the only way you can
> assure inconsistent configuration does not happen during reconfiguration.
> For example two inputs using the same vector or set up into the ExtINTA
> mode.  The original intent of the code was not to paper over breakage in
> the firmware.  You are trying to change it and it can be done, but it has
> to be justified well.
>
>> that patch just move that early before enable error vector.
>
>  What I am saying repeatedly is clearing of the I/O APIC is not guaranteed
> to happen for all the possible cases of Linux configuration.  Which means
> this is a partial solution only -- please try to propose a better one or
> provide the original problem report so that someone else can have a look
> at it.  What's triggering the error interrupt for example?  Is it
> recoverable?

ExtINT is routed to ioapic pin0. but the dst is set to 0.
and the systems has multi sockets with quadcore cpu, so the apic id of boot cpu
is set to 4 instead of 0

YH
