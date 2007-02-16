Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbXBPKrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbXBPKrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932253AbXBPKrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:47:14 -0500
Received: from 207.47.60.150.static.nextweb.net ([207.47.60.150]:18732 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbXBPKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:47:13 -0500
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Fri, 16 Feb 2007 10:47:11 +0000
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and
 disableunsupported config options.
From: Keir Fraser <keir@xensource.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Christian Limpach <Christian.Limpach@xensource.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Chris Wright <chrisw@sous-sol.org>,
       Andi Kleen <ak@muc.de>, <xen-devel@lists.xensource.com>,
       Ian Pratt <Ian.Pratt@xensource.com>, <virtualization@lists.osdl.org>,
       Steven Hand <steven.hand@cl.cam.ac.uk>, <linux-kernel@vger.kernel.org>
Message-ID: <C1FB3C2F.98E9%keir@xensource.com>
Thread-Topic: [patch 14/21] Xen-paravirt: Add XEN config options and
 disableunsupported config options.
Thread-Index: AcdRt8/EDlrZar2rEduvqQAX8io7RQ==
In-Reply-To: <20070216020947.03e1726e.akpm@linux-foundation.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/2/07 10:09, "Andrew Morton" <akpm@linux-foundation.org> wrote:

> Are the places where the domU code references machine addresses splattered
> all over the code?  If not, they can just be wrapped with
> preempt_disable/preempt_enable?

The main places where machine addresses are 'visible' are any code that
holds a pte_t,pmd_t,pud_t,pgd_t. We hide the machine-to-pseudophysical and
pseudophysical-to-machine translations inside e.g., pte_val() and __pte()
(i.e., constructors and extractors for page table entries). Obviously the
users of these macros are open coded all over the place, quite apart from
the performance cost of sprinkling preempt_{enable,disable} so liberally.

 -- Keir

