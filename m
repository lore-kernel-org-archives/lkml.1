Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbXGKIK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbXGKIK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbXGKIKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:10:12 -0400
Received: from main.gmane.org ([80.91.229.2]:38283 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731AbXGKIKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:10:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <matthieu.castet@parrot.com>
Subject: Re: [PATCH] signals: real-time signals delivery order
Date: Wed, 11 Jul 2007 07:34:14 +0000 (UTC)
Message-ID: <loom.20070711T092936-151@post.gmane.org>
References: <1184116335.19893.12.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 90.2.116.194 (Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.4) Gecko/20070508 Iceweasel/2.0.0.4 (Debian-2.0.0.4-1))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Salikhmetov <salikhmetov <at> gmail.com> writes:

> 
> From: Anton Salikhmetov <salikhmetov <at> gmail.com>
> 
> According to the POSIX standard, multiple real-time signals
> pending to a process should be delivered in a strict order.
> Specifically, the lowest-numbered signal should be delivered
> first and multiple occurrences of signals with the same number
> should be delivered in FIFO order.
> 
> Current Linux kernel delivers the highest-numbered signals
> pending to a process first, not the lowest-numbered ones. This
> contradicts to the requirement explained above. The problem can
> be demonstrated by the following test program:
I believe you should check that you mask or signal in your signal handler.
If you don't the high-prio handler will be prempted by low-prio, and they will
be executed in the reverse order.


Matthieu 

