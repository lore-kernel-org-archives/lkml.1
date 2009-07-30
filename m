Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbZG3VLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbZG3VLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZG3VLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:11:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:64716 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbZG3VLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:11:11 -0400
Message-ID: <4A720C5D.5090701@windriver.com>
Date: Thu, 30 Jul 2009 16:10:53 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Jun Koi <junkoi2004@gmail.com>, linux-kernel@vger.kernel.org,
       Bernhard Kaindl <bk@suse.de>,
       KGDB Mailing List <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: Firewire debugging tools - firedump & fireproxy?
References: <fdaac4d50907042242s6534d63at12a26df47a0f3b2a@mail.gmail.com> <1248932218.27010.8.camel@maxim-laptop>  <4A715A7B.3070406@windriver.com> <1248987456.13069.24.camel@maxim-laptop>
In-Reply-To: <1248987456.13069.24.camel@maxim-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2009 21:10:48.0796 (UTC) FILETIME=[3639B1C0:01CA115A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> On Thu, 2009-07-30 at 03:31 -0500, Jason Wessel wrote:
>>
>> 3) Develop a low level dedicated ethernet debug interface.  If you have
>> more than one ethernet, or an ethernet device that has multiple hardware
>> queues, it is plausible to have a dedicated way to talk to a device
>> which has no restrictions on getting preempted, or used by another part
>> of the kernel.  This lends itself to an ideal medium for kgdb
>> communications.

> Or, even better, to make in possible to switch between a normal, and
> exclusive mode?  Maybe this cab be done without (or with slight)
> modifications to network drivers.  Why not to make kgdb own the
> network device (use it exclusively), but use same interfaces as
> regular kernel does?

The key problem is how such a switch is governed between normal and
exclusive mode works.  If it involves locks kgdboe is not going to
work reliably from the exception context.

Having kgdboe directly own an interface and use the same kernel API as
the network stack won't work out of the box because there is probing,
interrupt control and lots of other tidbits.  This is a case where the
polling API needs some work or a dedicated API is needed, because this
is a case where you really don't want the whole network stack
involved.  IE it would be nice to be able to debug the networking
stack with kgdboe.

Patches which implement new functionality, ideas and discussion about
any aspect of kernel debugging are always welcome on the kgdb mailing
list. :-)

Cheers,
Jason.

