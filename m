Return-Path: <linux-kernel-owner+w=401wt.eu-S1751225AbZGaFAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbZGaFAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 01:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbZGaFAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 01:00:43 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45499 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZGaFAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 01:00:42 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jul 2009 01:00:41 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MA/wkLCfDUzlFq0BaRRTMb7b8pfBrg+01yeH1S4Gp1TUAeXd8CYGF2bNDtrFzTeLJG
         T52+weB84XIWPhXOh0j2zYgBYGc3NAGXYkOmFqOqruZjI/1o6FDQSMYU9Ptmd779fUjm
         gOgHqvehG1hoGed0L250pvqIjaEuSe5UnsrLQ=
Subject: Re: Firewire debugging tools - firedump & fireproxy?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Jun Koi <junkoi2004@gmail.com>, linux-kernel@vger.kernel.org,
       Bernhard Kaindl <bk@suse.de>,
       KGDB Mailing List <kgdb-bugreport@lists.sourceforge.net>
In-Reply-To: <4A720C5D.5090701@windriver.com>
References: <fdaac4d50907042242s6534d63at12a26df47a0f3b2a@mail.gmail.com>
	 <1248932218.27010.8.camel@maxim-laptop>  <4A715A7B.3070406@windriver.com>
	 <1248987456.13069.24.camel@maxim-laptop>  <4A720C5D.5090701@windriver.com>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 07:55:17 +0300
Message-Id: <1249016117.19210.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 16:10 -0500, Jason Wessel wrote:
> Maxim Levitsky wrote:
> > On Thu, 2009-07-30 at 03:31 -0500, Jason Wessel wrote:
> >>
> >> 3) Develop a low level dedicated ethernet debug interface.  If you have
> >> more than one ethernet, or an ethernet device that has multiple hardware
> >> queues, it is plausible to have a dedicated way to talk to a device
> >> which has no restrictions on getting preempted, or used by another part
> >> of the kernel.  This lends itself to an ideal medium for kgdb
> >> communications.
> 
> > Or, even better, to make in possible to switch between a normal, and
> > exclusive mode?  Maybe this cab be done without (or with slight)
> > modifications to network drivers.  Why not to make kgdb own the
> > network device (use it exclusively), but use same interfaces as
> > regular kernel does?
> 
> The key problem is how such a switch is governed between normal and
> exclusive mode works.  If it involves locks kgdboe is not going to
> work reliably from the exception context.
I mean the switch should happen just once, when kgdboe is loaded, and
back when unloaded.


> 
> Having kgdboe directly own an interface and use the same kernel API as
> the network stack won't work out of the box because there is probing,
> interrupt control and lots of other tidbits.  This is a case where the
> polling API needs some work or a dedicated API is needed, because this
> is a case where you really don't want the whole network stack
> involved.  IE it would be nice to be able to debug the networking
> stack with kgdboe.
Sure, but I feel that doing any significant changes to _all_ ethernet
drivers is a huge job.

> 
> Patches which implement new functionality, ideas and discussion about
> any aspect of kernel debugging are always welcome on the kgdb mailing
> list. :-)


Best regards,
	Maxim Levitsky

> 
> Cheers,
> Jason.
> 

