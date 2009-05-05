Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbZEEXRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbZEEXRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZEEXRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:17:39 -0400
Received: from sous-sol.org ([216.99.217.87]:55464 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752021AbZEEXRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:17:39 -0400
Date: Tue, 5 May 2009 16:17:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Message-ID: <20090505231718.GT3036@sequoia.sous-sol.org>
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0049CD.3080003@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (gregory.haskins@gmail.com) wrote:
> So you would never have someone making a generic
> hypercall(KVM_HC_MMU_OP).  I agree.

Which is why I think the interface proposal you've made is wrong.  There's
already hypercall interfaces w/ specific ABI and semantic meaning (which
are typically called directly/indirectly from an existing pv op hook).

But a free-form hypercall(unsigned long nr, unsigned long *args, size_t count)
means hypercall number and arg list must be the same in order for code
to call hypercall() in a hypervisor agnostic way.

The pv_ops level need to have semantic meaning, not a free form
hypercall multiplexor.

thanks,
-chris
