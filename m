Return-Path: <linux-kernel-owner+w=401wt.eu-S932347AbXBNP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbXBNP1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 10:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932349AbXBNP1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 10:27:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57351 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932347AbXBNP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 10:27:19 -0500
Date: Wed, 14 Feb 2007 15:40:14 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <alan@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] adjust legacy IDE resource setting
Message-ID: <20070214154014.7fa76711@localhost.localdomain>
In-Reply-To: <45D33344.76E4.0078.0@novell.com>
References: <45D33344.76E4.0078.0@novell.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 15:05:24 +0000
"Jan Beulich" <jbeulich@novell.com> wrote:

> The change to force legacy mode IDE channels' resources to fixed
> non-zero values confuses (at least some versions of) X, because the
> values reported by the kernel and those readable from PCI config space
> aren't consistent anymore. Therefore, this patch arranges for the
> respective BARs to also get updated if possible.

If X is getting confused fix X. Those BARs are *undefined* in legacy
mode. The value in them is undefined, the results that end up there if
you do write to them are undefined too. If X believes those BAR values
blindly it'll do the wrong thing in some freaky cases.

Which specific versions of X are problematic ?

As to the implementation:
	start and end as passed are the real I/O values so you don't need
to mask them that I can see.

I've no fundamental problem with writing the BAR values back to avoid
confusing some apparently broken X, but I'd like to know what X, what
circumstances and that X is also getting fixed.

Alan
