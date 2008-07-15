Return-Path: <linux-kernel-owner+w=401wt.eu-S1761368AbYGOPbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761368AbYGOPbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbYGOPbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:31:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:19000 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYGOPbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hh8oTaPkT4eVWsmgYW4n0fEVpd6XG0WBPg7Vs2EX2C7U9IQ4YeCJU6Kv6kqUeEbO6x
         1n7/t0RvhfWsaDZxKE+WIuulWg2Ylq03daO8vzYECS2xbSyg5qGMzh+FQbKTyI7Sw2fY
         nf5FfXz8x1x7E4SGwg4coJutWTQfQP22rvxWM=
Message-ID: <4dfa50520807150831i519a3a43n635ab7e58d35ba5e@mail.gmail.com>
Date: Tue, 15 Jul 2008 09:31:29 -0600
From: "David Hubbard" <david.c.hubbard@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [RFC] (almost) booting allyesconfig -- please don't poke super-io without request_region
Cc: "Hans de Goede" <j.w.r.degoede@hhs.nl>, linuxppc-dev@ozlabs.org,
       "Samuel Ortiz" <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       "Milton Miller" <miltonm@bga.com>, lm-sensors@lm-sensors.org
In-Reply-To: <20080715103613.4fbbf01f@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <for-27-patch1-0@bga.com> <4879A144.8060203@hhs.nl>
	 <4dfa50520807131411ied883cgcb20eb6bd94f761@mail.gmail.com>
	 <487A7211.7030309@hhs.nl>
	 <4dfa50520807131426t4013142cp1fcd49e078a79c1f@mail.gmail.com>
	 <20080714095914.0644ac5d@hyperion.delvare>
	 <88f5162604470179b3c6ebfe729a46f5@bga.com> <487B8D2C.1090208@hhs.nl>
	 <4dfa50520807141055l532caaaai700255936600e5ae@mail.gmail.com>
	 <20080715103613.4fbbf01f@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Tue, Jul 15, 2008 at 2:36 AM, Jean Delvare <khali@linux-fr.org> wrote:
>> Is there any way to use lspci and start at the LPC bridge, then find
>> the SuperIO chip's IO address? What about ACPI tables? Perhaps probing
>> logic could look for an LPC bridge before probing certain IO addresses
>> even if the addresses are not in the LPC bridge config.
>
> I always assumed that there was no way to know in advance if a
> Super-I/O (LPC) chip was present or not, let alone the exact model of
> the chip. The I/O addresses are decoded by the Super-I/O chip itself,
> and in general it has no relation to PCI. And I've never seen ports
> 0x2e/0x2f nor 0x4e/0x4f listed in /proc/ioports.
>
> But of course if there is a way to know, we should use it. Avoiding
> random access to I/O ports, even if they are relatively standard in
> this case, is always good.

I looked at my lspci output and did a little researching, and I think
the only thing we can deduce is that there is an LPC bridge, so
looking for a SuperIO is a good idea. If there is no LPC bridge
listed, I can't say whether probing the ports is a good idea or not.

David
