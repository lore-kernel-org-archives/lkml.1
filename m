Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbZFSBi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbZFSBi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 21:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZFSBiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 21:38:50 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40141 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZFSBiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 21:38:50 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's no local APIC
References: <4A329CF8.4050502@goop.org> <m1d499yyug.fsf@fess.ebiederm.org>
	<4A35ACB3.9040501@goop.org> <m1k53dbwo2.fsf@fess.ebiederm.org>
	<4A36B3EC.7010004@goop.org> <m1fxe117n5.fsf@fess.ebiederm.org>
	<4A37F4AE.5050902@goop.org> <m1vdmvxe3u.fsf@fess.ebiederm.org>
	<4A392896.9090408@goop.org> <m1zlc6memu.fsf@fess.ebiederm.org>
	<4A3A96BC.1000302@goop.org> <m1ab45i8vs.fsf@fess.ebiederm.org>
	<4A3AACFD.5020805@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 18 Jun 2009 18:38:41 -0700
In-Reply-To: <4A3AACFD.5020805@goop.org> (Jeremy Fitzhardinge's message of "Thu\, 18 Jun 2009 14\:09\:17 -0700")
Message-ID: <m1zlc5f1em.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jeremy@goop.org, keir.fraser@eu.citrix.com, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Ah, OK.  The pirq is set up for a specific domain rather than being
> global (otherwise it would need some kind of "which domain can access
> which pirq" table).  dom0 can either create a pirq for itself or someone
> else, and the final user of the pirq binds it to a domain-local evtchn.
>
> I think.  I really haven't looked into the pci-passthrough parts very
> closely yet.

I certainly could not find the code that would let you setup a pirq for another
domain.  In fact the pirq code aka alloc_vectors appears to hard code dom0
in Xen 3.4.

pci-passthrough since it is domU, and since you describe it as well isolated and
comparatively simple should be a shoe in.

Further as you describe it pci-passthrough is a subset of what we have to do for dom0.
So if we can I would like to see the pci passthrough code get merged first.

Eric
