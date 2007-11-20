Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbXKTCrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbXKTCrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXKTCrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:47:13 -0500
Received: from ozlabs.org ([203.10.76.45]:38479 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbXKTCrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:47:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18242.19032.390727.850649@cargo.ozlabs.ibm.com>
Date: Tue, 20 Nov 2007 13:45:44 +1100
From: Paul Mackerras <paulus@samba.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <clameter@sgi.com>, ak@suse.de,
       akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 37/45] x86_64: Support for fast per cpu operations
In-Reply-To: <47423FB7.20800@zytor.com>
References: <20071120011132.143632442@sgi.com>
	<20071120011340.569486037@sgi.com>
	<47423FB7.20800@zytor.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:

> There was, at some point, discussion about using the gcc TLS mechanism, 
> which should permit even better code to be generated.  Unfortunately, it 
> would require gcc to be able to reference %gs instead of %fs (and vice 
> versa for i386), which I don't think is available in anything except 
> maybe the most cutting-edge version of gcc.
> 
> However, if we're doing a masssive revampt it would be good to get an 
> idea of how to migrate to that model eventually, or why it doesn't make 
> sense at all.

The problem I found when I tried to do that on powerpc is that gcc
believes it can cache addresses of TLS variables.  If you try and use
TLS accesses for per-cpu variables then you end up accessing the wrong
cpu's variables due to that, since our "TLS" pointer can change at any
point where preemption is enabled.

If we wanted to do per-task variables then TLS would be perfect for
that.

Paul.
