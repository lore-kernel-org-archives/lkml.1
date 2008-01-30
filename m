Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbYA3AgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbYA3AgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYA3AgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:36:04 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:45348 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYA3AgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:36:01 -0500
Date: Wed, 30 Jan 2008 01:35:58 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jon Masters <jonathan@jonmasters.org>
cc: Pavel Roskin <proski@gnu.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
In-Reply-To: <1201652420.2271.91.camel@perihelion>
Message-ID: <Pine.LNX.4.64.0801300129270.14907@fbirervta.pbzchgretzou.qr>
References: <1201641765.18773.35.camel@dv> <1201652420.2271.91.camel@perihelion>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 29 2008 19:20, Jon Masters wrote:
>On Tue, 2008-01-29 at 16:22 -0500, Pavel Roskin wrote:
>> 
>> It have come to my attention that a patch has been committed to the
>> kernel with the explicit purpose of tainting ndiswrapper - the kernel
>> module allowing Windows NDIS drivers for Ethernet and Wireless cards to
>> be used by the kernel.
>> 
>> That's the commit in question:
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0aa5bd52d0c49ca56d24584c646e6544ccbb3dc9
>
>Yup. There was (what I thought was) a bug in the existing logic (an
>explicit match on "ndiswrapper", and a setting of the global kernel
>taint flags) and I corrected it to do what I thought it was actually
>intending to do, but hadn't been. Was I mistaken? What's the point of
>setting the global taint if we don't know why we set that?

ftr, as a by-stander, I perceived the past discussions as a lack of
trust from other kernel developers that Ndiswrapper will always set
the taint flags correctly. (ndiswrapper code does not go through lkml
review so the magic line might just change between tarballs.)

>> - ndiswrapper is licensed under GPL
>
>Yes it is. But I thought the existing code was intending to taint the
>kernel (that's what it does), so it would really help to identify why it
>tainted the kernel, by calling add_taint_module instead of add_taint. I
>didn't put the existing match in there...don't shoot the messenger :)
>
>> - ndiswrapper needs GPL-only symbols
>
>Another fix would be for ndiswrapper to explicitly set the taint when it
>loads a tainted driver? Or do we just want to go back to globally
>"tainting" the kernel without assigning the blame to any module?

I think the global taint flag is always needed because you never know
what the proprietary module actually did to our memory. Unloading
the driver and ndiswrapper should retain some sort of taintedness
should it oops much later.
