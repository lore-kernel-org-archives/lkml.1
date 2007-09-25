Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbXIYFE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbXIYFE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 01:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbXIYFEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 01:04:52 -0400
Received: from science.horizon.com ([192.35.100.1]:10457 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752816AbXIYFEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 01:04:51 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2007 01:04:50 EDT
Date: 25 Sep 2007 00:58:08 -0400
Message-ID: <20070925045808.12273.qmail@science.horizon.com>
From: linux@horizon.com
To: vegard.nossum@horizon.com
Subject: Re: [RFC] New kernel-message logging API
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know. Compare the following two lines:
> 
> printk(KERN_INFO "Message.\n");
> kprint_info("Message.");
> 
> By dropping the lengthy macro (it's not like it's going to change
> while we're running anyway, so why not make it a part of the function
> name?) and the final newline, we actually end up with a net decrease
> in line length.

Agreed.  In fact, you may want to write a header that implements the
kprint_ functions in terms of printk for out-of-core driver writers to
incorporate into their code bases, so they can  upgrade their API while
maintaining backward compatibility.  (If it were me, I'd also give it
a very permissive license, like outright public domain, to encourage use.)

> I thought it would be nice to have something that looks familiar,
> since that would ease an eventual transition. klog is a valid
> alternative, but isn't kp a bit cryptic?

Well, in context:
	kp_info("Message.");

Even the "kp_" prefix is actually pretty unnecessary.  It's "info"
and a human-readable string that make it recognizable as a log message.

Another reason to keep it short is just that it's going to get typed a LOT.

Anyway, just MHO.
