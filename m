Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYKDTz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYKDTz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYKDTzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:55:18 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:49781 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYKDTzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:55:17 -0500
Message-ID: <ac3eb2510811041155s3ef2df93w8fdd7ce7c009e994@mail.gmail.com>
Date: Tue, 4 Nov 2008 20:55:15 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Nathaniel McCallum" <nathaniel@natemccallum.com>
Subject: Re: [RFC] [PATCH] Loaded driver modalias
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <491096D7.10808@natemccallum.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491096D7.10808@natemccallum.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2008 at 19:39, Nathaniel McCallum
<nathaniel@natemccallum.com> wrote:
> Please CC me to responses as I'm not subscribed to LKML.  Also, this is my
> first kernel patch, advise is certainly welcome.
>
> For something I'm working on I have the need to answer the question, "given
> a hardware ID, does Linux distro X have a driver to support this hardware?"
> and more specifically, "which drivers support this hardware?" I can,
> generally speaking, get this data from files like
> /lib/modules/*/modules.alias.  However, this does not work for drivers built
> into the kernel.  With that in mind, I've cooked up a little proof of
> concept. Basically, its a sysfs file
> /sys/modules/$module/drivers/$driver/modalias that, when read, contains
> modalias-style filters for this driver.
>
> The attached patch only does this for PCI drivers, each subsystem would need
> a patch like this.  Is this idea crazy?  Is there a better implementation?

Hmm, what if that gets larger than 4k? It seems not really like
something for sysfs. There are also drivers which export a modalias
which matches more devices, than the device it actually would accept
to bind to. Some driver have logic in the match() function to exclude
stuff.

What's the exact information you need? Would it be sufficient  to ask
a bus with a modalias string, which driver of that bus matched that
device?

Kay
