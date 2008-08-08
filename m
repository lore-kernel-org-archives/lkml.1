Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYHHABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYHHABU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYHHABM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:01:12 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:18063 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbYHHABL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UvgaqrbbkHeOC/094pV7xegzwqj7g2UVwQuOssPa5dcLUqcTSiEVLbSFaALdkYdD07
         3hlD9g8ecMCKmRhkff7oLE9+InchergC1eMoD42rERhMux+niuZptgvbEmGY/vlCSuwM
         ToRdDz2B8SOVqP4Gssl9ccqybvVCOW6lFArdE=
Message-ID: <86802c440808071701j4ebdc15u16e8d0e77b945c2f@mail.gmail.com>
Date: Thu, 7 Aug 2008 17:01:10 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Zachary Amsden" <zach@vmware.com>,
       "Alok Kataria" <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <489B8A68.10900@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218136365.23770.52.camel@alok-dev1> <489B6710.9000604@kernel.org>
	 <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>
	 <489B836A.3050209@goop.org> <489B84EF.6050009@kernel.org>
	 <489B8948.6060003@goop.org> <489B8A68.10900@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2008 at 4:51 PM, H. Peter Anvin <hpa@kernel.org> wrote:
> Jeremy Fitzhardinge wrote:
>>
>> H. Peter Anvin wrote:
>>>
>>> The fixmap area should never have been made movable.  It's utter
>>> braindamage.
>>
>> Shrug.  It's been like that for a couple of years now.  It was one of the
>> very first paravirt-ops patches.  It wasn't controversial then, and nobody
>> seems to have noticed since.
>
> The Linux kernel was never a paragon of perfection - it was never meant to
> be.  Just because a bit of cruft went unnoticed into the kernel doesn't mean
> we shouldn't fix it.
>
>>> Given the x86 architecture, it's inevitable that PV will want to reserve
>>> address space at the top of memory, and therefore the fixmap area needs to
>>> be moved out of that space.
>>
>> OK.  But there's a few places where the code uses FIXADDR_TOP to mean "top
>> of kernel address space", so we'd need to come up with a proper symbol for
>> that.

why not reserving that in e820 table?

YH
