Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXBNPpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXBNPpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 10:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932345AbXBNPpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 10:45:06 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:22401
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932344AbXBNPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 10:45:05 -0500
Message-Id: <45D33CF9.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Wed, 14 Feb 2007 15:46:49 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Alan" <alan@lxorguk.ukuu.org.uk>
Cc: <alan@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] adjust legacy IDE resource setting
References: <45D33344.76E4.0078.0@novell.com>
 <20070214154014.7fa76711@localhost.localdomain>
In-Reply-To: <20070214154014.7fa76711@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Alan <alan@lxorguk.ukuu.org.uk> 14.02.07 16:40 >>>
>On Wed, 14 Feb 2007 15:05:24 +0000
>"Jan Beulich" <jbeulich@novell.com> wrote:
>
>> The change to force legacy mode IDE channels' resources to fixed
>> non-zero values confuses (at least some versions of) X, because the
>> values reported by the kernel and those readable from PCI config space
>> aren't consistent anymore. Therefore, this patch arranges for the
>> respective BARs to also get updated if possible.
>
>If X is getting confused fix X. Those BARs are *undefined* in legacy
>mode. The value in them is undefined, the results that end up there if
>you do write to them are undefined too. If X believes those BAR values
>blindly it'll do the wrong thing in some freaky cases.
>
>Which specific versions of X are problematic ?

The one I ran into problems with is reporting

X Window System Version 6.9.0
Release Date: 21 December 2005

(used in SLES10, the specific package version is xorg-x11-6.9.0-50.14)

>As to the implementation:
>	start and end as passed are the real I/O values so you don't need
>to mask them that I can see.

The masking is done primarily to (a) calculate the correct length (from a BAR's
perspective), as I don't want to write the BAR if its length doesn't match the
expectation, and (b) to properly report the new value in the printk.

>I've no fundamental problem with writing the BAR values back to avoid
>confusing some apparently broken X, but I'd like to know what X, what
>circumstances and that X is also getting fixed.

Of course I also opened a bug against X, as I too think it's doing something
wrong here.

Jan
