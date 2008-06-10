Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbYFJFJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbYFJFJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 01:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYFJFIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 01:08:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:9689 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYFJFIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 01:08:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vdaBpTP+4Oip1NQ7Kaiaec5ISm+r2C3aPvInEBVCjAcY3eFEtL2tX7FoRnNAN2C/5y
         PbpGvPNuzvwEn4CRWEq8+b35oqcx2rRBgRA9v0eIFnBHwc6YSdXQ0tmgjzu16BG5T9Um
         veggti8yXXQ7cGdVkRSrR4z3I5qEVtrLWxv6k=
Message-ID: <86802c440806092208s338cf6b6q892f5149bbd142ca@mail.gmail.com>
Date: Mon, 9 Jun 2008 22:08:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
In-Reply-To: <Pine.LNX.4.55.0806100341520.31588@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-10-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-11-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-12-git-send-email-gcosta@redhat.com>
	 <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl>
	 <484D8813.4040807@redhat.com>
	 <Pine.LNX.4.55.0806092058550.26593@cliff.in.clinika.pl>
	 <86802c440806091353m240ab7adocbaf5dacd15504f7@mail.gmail.com>
	 <Pine.LNX.4.55.0806092159350.26593@cliff.in.clinika.pl>
	 <Pine.LNX.4.55.0806100341520.31588@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 7:46 PM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Mon, 9 Jun 2008, Maciej W. Rozycki wrote:
>
>> > we need clear_IO_APIC before enable setup error vector, in case there
>> > is wrong setting in ioapic by BIOS...
>>
>>  Fair enough, although it is still interesting why it would only trigger
>> in the 64-bit mode and why shouldn't the BIOS be fixed instead.
>
>  Then again -- what if X86_LOCAL_APIC is set, but X86_IO_APIC is not?

config X86_LOCAL_APIC
        def_bool y
        depends on X86_64 || (X86_32 && (X86_UP_APIC || ((X86_VISWS ||
SMP) && !X86_VOYAGER) || X86_GENERICARCH))

config X86_IO_APIC
        def_bool y
        depends on X86_64 || (X86_32 && (X86_UP_IOAPIC || (SMP &&
!(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH))

for 64bit, those are all set.

for 32bit, may need to null stub if X86_IO_APIC is not set

YH
