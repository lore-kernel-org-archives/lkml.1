Return-Path: <linux-kernel-owner+w=401wt.eu-S1761312AbXLREfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761312AbXLREfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 23:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXLREfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 23:35:23 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60976 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbXLREfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 23:35:22 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>, "Huang, Ying" <ying.huang@intel.com>,
       akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v3] x86 boot : export boot_params via sysfs
References: <1197620206.12999.12.camel@caritas-dev.intel.com>
	<20071214155228.GA13342@kroah.com> <4762C78D.9080107@zytor.com>
	<4762D2CC.1030109@zytor.com>
Date: Mon, 17 Dec 2007 21:34:23 -0700
In-Reply-To: <4762D2CC.1030109@zytor.com> (H. Peter Anvin's message of "Fri,
	14 Dec 2007 11:00:28 -0800")
Message-ID: <m1abo8d3jk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> This is directly analogous to how we treat identity information in IDE, or PCI
> configuration space -- some fields are pre-digested, but the entire raw
> information is also available.

Add to that a totally unchanged value can just be easier to get correct.

Still the kexec code as much as it can should not look there, as we may
get the same basic information in a couple of different ways.

EFI memmap vs. e820 for example.  If/when that is the case /sbin/kexec
should get the information and spit it out into whatever format makes
sense for the destination kernel.  My sense is just passing through
values is brittleness where we don't want it.

However I think being able to get at the raw boot information overall
sounds useful.  I just don't know if it is generally useful or just
useful when debugging bootloaders though.

Eric
