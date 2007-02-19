Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbXBSFS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbXBSFS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 00:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbXBSFS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 00:18:26 -0500
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:35300 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752879AbXBSFSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 00:18:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qdWMJ3SpkXqcoMSKQrq6PsEtxITTn4wiECPhLrgDWL3QF5Ln+XGtaY82/Nq/1pzur6WyU43E13vicjyNqsFXsqKWMRyIpPzaK/lc7rKXQZqK+apOWjYqDg7ezo3XgcnS017ep/WmNLJyIVpcUvbgZZub450EBNzKKYdEzeJ2Fug=  ;
X-YMail-OSG: JvAXFI8VM1mu_af61DKNRTe66C_LBIc_f5ykSiLGD.72QeHXks1d0xDG9OH.zrSwDZUS_V0FPn_YILRbceH4c6ZRNknq2oCf8n9NCr5UELX14CJIc4hjbVUx0oTwow22zQOp96K_tJxtyjo-
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20-mm2
Date: Sun, 18 Feb 2007 21:13:03 -0800
User-Agent: KMail/1.7.1
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <200702190032.09052.rjw@sisk.pl> <20070218162822.3fd10212.akpm@linux-foundation.org>
In-Reply-To: <20070218162822.3fd10212.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702182113.03481.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 February 2007 4:28 pm, Andrew Morton wrote:
> On Mon, 19 Feb 2007 00:32:08 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 

> > One more thing:
> > 
> > rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> > Unable to handle kernel NULL pointer dereference at 0000000000000030 RIP: 
> >  [<ffffffff804032c3>] rtc_sysfs_remove_device+0x23/0x50
> > 	...
> > Call Trace:
> >  [<ffffffff803c5786>] class_device_del+0x86/0x180
> >  [<ffffffff803c5891>] class_device_unregister+0x11/0x20
> >  [<ffffffff8040280e>] rtc_device_unregister+0x3e/0x50
> >  [<ffffffff880cd789>] :rtc_cmos:cmos_pnp_probe+0x219/0x240
> >  [<ffffffff803988a1>] pnp_device_probe+0xa1/0xe0
> >  ...
> 
> How did you provoke that?  modprobe rtc-cmos?

Plus, I'd guess, the old rtc driver statically linked.

What I see is a should-not-happen fault of some kind in a cleanup
path that's been tested with non-PNP rtc drivers.  A quick glance
at the code left me puzzled.  Would sleeping a second or two before
calling rtc_device_unregister() change that behavior?

- Dave
