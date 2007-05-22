Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbXEVXPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbXEVXPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbXEVXPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:15:39 -0400
Received: from gw.goop.org ([64.81.55.164]:33853 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655AbXEVXPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:15:38 -0400
Message-ID: <46537996.20302@goop.org>
Date: Wed, 23 May 2007 00:15:34 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: section mismatches
References: <20070522145245.727813f3.akpm@linux-foundation.org>
In-Reply-To: <20070522145245.727813f3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> WARNING: vmlinux(.text+0xc02fe884): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
> WARNING: vmlinux(.data+0xc0439099): Section mismatch: reference to .init.text:xen_start_kernel (between 'startup_xen' and 'boot_gdt_descr')
>   

This is safe, but I'll clean it up.  I'll also have a look at iret_exc,
some of which might be Xen-related.  Actually, iret_exc is in the fixup
section, but it gets used from several places, so it might be worth just
making it .text.

    J
