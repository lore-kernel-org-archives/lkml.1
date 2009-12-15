Return-Path: <linux-kernel-owner+w=401wt.eu-S933668AbZLOVHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668AbZLOVHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760214AbZLOVHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:07:20 -0500
Received: from 216-239-44-51.google.com ([216.239.44.51]:38225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760194AbZLOVHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:07:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=eEXgL42CNImggIcV+9U2FoTdhkyBIXjLpc/q55cNihPmxfcIK0yj0xew6NNnbFQe4
	rs77MxR3ene8mjGgrSaLg==
MIME-Version: 1.0
In-Reply-To: <20091215204803.GA26319@shareable.org>
References: <4B1ECEEE.3000209@bluewatersys.com>
	 <20091210172458.GJ19454@elf.ucw.cz>
	 <4B2150B7.3040207@bluewatersys.com>
	 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
	 <20091211221015.GB24456@elf.ucw.cz>
	 <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com>
	 <20091214064545.GK5114@elf.ucw.cz>
	 <1260813293.13078.15.camel@c-dwalke-linux.qualcomm.com>
	 <BD79186B4FD85F4B8E60E381CAEE19090200E9C6@mi8nycmail19.Mi8.com>
	 <20091215204803.GA26319@shareable.org>
Date: Tue, 15 Dec 2009 13:07:13 -0800
Message-ID: <a55d774e0912151307i12777a67jabf190742be3883e@mail.gmail.com>
Subject: Re: GPIO support for HTC Dream
From: Brian Swetland <swetland@google.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       Daniel Walker <dwalker@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
       Iliyan Malchev <malchev@google.com>,
       "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Ryan Mallon <ryan@bluewatersys.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 12:48 PM, Jamie Lokier <jamie@shareable.org> wrote:
>
> Perhaps the Dream's GPIOs are similar, but with opposite polarity.
> If it also has the same transition driving spike, writing a 1->0
> transition would be bad for the hardware making the shadow variable
> even more important.

Arve will certainly step in if I'm wrong here, but I believe the issue
is that the dream CPLD GPIOs (which is what we're talking about, not
the MSM7K's onboard GPIOs which are more flexible) have no way to read
the set output state back.  So, you can't read-modify-write to change
just one of the 8 bits in a given bank.  The default mask values in
the android msm tree's trout gpio board files are based on what he
shipping HTC bootloader initializes things to.

Brian
