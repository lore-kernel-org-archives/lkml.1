Return-Path: <linux-kernel-owner+w=401wt.eu-S1030787AbXD1Ezr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030787AbXD1Ezr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 00:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965427AbXD1Ezr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 00:55:47 -0400
Received: from ozlabs.org ([203.10.76.45]:38972 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965044AbXD1Ezp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 00:55:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17970.53875.506097.699517@cargo.ozlabs.ibm.com>
Date: Sat, 28 Apr 2007 14:49:55 +1000
From: Paul Mackerras <paulus@samba.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 20/38] Minor fault path optimization.
In-Reply-To: <20070427140516.523272684@de.ibm.com>
References: <20070427140503.087958775@de.ibm.com>
	<20070427140516.523272684@de.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky writes:

> The minor fault path has grown a lot in terms of cycles. In particular
> the kprobes hook is very costly. Optimize the path to save a couple of
> cycles. If kprobes is enabled more than 300 cycles can be avoided if 
> kprobes_running() is false.

There's no good reason to use a notifier for page faults, since
there's only one external piece of code that wants to know about
them...

Regards,
Paul.
