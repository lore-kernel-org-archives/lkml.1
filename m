Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbZFECxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbZFECxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 22:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZFECwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 22:52:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:56293 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbZFECwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 22:52:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qyE5hGNODk22muJLNl9SqMfjEQW5kp2iWOyFe/HwMRWbLOohz3YwG3x7gpr1i6zpKd
         sIEE9uKfT9S9KlpoKsIRBZal58CDqdpa61RIydMh4Zoh/UGCx/lrknUZJ00v2QbthufU
         7v8Vc8o5AHoAP+ccoiL4tX2N90EUBGR79+kkI=
MIME-Version: 1.0
In-Reply-To: <200906031045.45005.rjw@sisk.pl>
References: <20090601101614.10720.93804.sendpatchset@rx1.opensource.se>
	 <200906012133.32074.rjw@sisk.pl>
	 <aec7e5c30906012133w74d7d843jccad99c564a308ec@mail.gmail.com>
	 <200906031045.45005.rjw@sisk.pl>
Date: Fri, 5 Jun 2009 11:52:53 +0900
Message-ID: <aec7e5c30906041952q5dd0ae66n8c72a28f075d384@mail.gmail.com>
Subject: Re: [PATCH] Driver Core: Add platform device arch data V2
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, khilman@deeprootsystems.com,
       gregkh@suse.de, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 5:45 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> On Tuesday 02 June 2009, Magnus Damm wrote:
>> However, a typical embedded system has a wide range of platform
>> devices. Some are for the SoC itself and some are for external
>> devices, like on board ethernet controlllers (not on chip like the SoC
>> platform devices).
>
> Why don't we use the arch-specific wrapping for all platform devices on this
> arch, the SoC ones and the non-SoC ones?  Is there any particular reason not
> to do that?

There are quite a few in-tree platform device drivers for SuperH that
can run on both ARM and SuperH. Maybe even MIPS in the future, who
knows. And we already have a perfectly fine platform device interface
that we can share, so I don't see any reason why we should invent
something new all of a sudden.

> If idle() and wakeup() are supposed to be platform-specific, and quite frankly
> I don't see how they could be implemented in a generic way, they don't even
> need to operate on struct platform_device objects.

The implementation can be platform specific, but the interface should
be shared across architectures. This so we can use the same device
driver on multiple architectures.

If you dislike the idea of operating on struct platform_device then
how about letting idle()/wakeup() or enable()/disable() take a pointer
to struct device instead of struct platform_device?

In my opinion it makes sense to allow architectures to add data to
struct platform_device since it's platform devices we're going to do
runtime PM on. For architectures not using struct pdev_archdata there
is really no additional runtime cost.

>> If you guys dislike adding arch specific data to struct platform
>> device then for SuperH we can just (mis)use the arch specific data in
>> struct device instead. I'm afraid that solution wastes memory since
>> the data will only be used for platform devices anyway. So I prefer
>> adding arch specific data to struct platform_device instead of struct
>> device if possible.
>
> That's generally OK, but I'd like to get convinced that there's no better
> way indeed.

The earlier version did something ugly with Kconfig. That's even worse IMO.

> What I personally don't like about the patch is the duplication of empty
> struct pdev_archdata for quite a number of architectures.  It's not nice and
> I wonder if there's a way to avoid it.

I don't think there's any other way around that than Kconfig. The per
arch duplication of empty structures is already done for struct device
so it can't be that bad.

Thanks for your help!

/ magnus
