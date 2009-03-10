Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZCJE17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZCJE17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 00:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZCJE1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 00:27:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbZCJE1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 00:27:49 -0400
Date: Mon, 9 Mar 2009 21:26:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesper Krogh <jesper@krogh.cc>
cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <49B57F3D.5030008@krogh.cc>
Message-ID: <alpine.LFD.2.00.0903092109460.19207@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6F39F.9040801@krogh.cc>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com> 
 <49A70B24.6090706@krogh.cc>  <1235685269.6811.11.camel@localhost.localdomain>  <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>  <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>  <1235766936.7402.5.camel@localhost.localdomain>
 <49ABACA0.3090300@krogh.cc>  <1236029277.7756.0.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc>  <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc>  <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>  <49AECA3B.5030503@krogh.cc>
  <1236193075.3793.63.camel@jstultz-laptop>  <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Mar 2009, Jesper Krogh wrote:
> 
> First boot.
> [    0.000000] ref_freq: 2311825  pit_freq: 2310386
> Second boot:
> [    0.000000] ref_freq: 2311803  pit_freq: 2310190
> Third boot:
> [    0.000000] ref_freq: 2311824  pit_freq: 2310080
> Fourth boot:
> [    0.000000] ref_freq: 2311831  pit_freq: 2310130

It's really quite impressively stable, but the fast-PIT calibration 
frequency is reliably about 3/4 of a promille low. Or, put another way, 
the TSC difference over the pit calibration is just a _tad_ too small 
compared to the value we'd expect if that loop of pit_expect_msb() would 
really run at the expected delay of a 1.193182MHz clock divided by 256.

And it's stable in that it really always seems to be off by a very similar 
amount. It's not moving around very much.

I also wonder why it seems to happen mainly just to _you_. There's 
absolutely nothing odd in your system, neither a slow CPU or anything 
else that would stand out.

Grr. Very annoyingly non-obvious.

		Linus
