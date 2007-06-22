Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbXFVV72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbXFVV72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbXFVV7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:59:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:30764 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbXFVV7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s5BOMmiDXh4+dY72kNwtFAzgMBad8fji+Pbb9xcQ5BkDx5Nc+fblTusO8YIUXwM63s4UI13sxzF6wm/LPjr7J2EzBkat2aXY0bYgwNVVM1LdSlrPzE3donsGAhOYMaCySMWxAe+/xJRBCKGqvD4TEqMdWqh6Go9s4JiAHYKbT6I=
Message-ID: <86802c440706221459x51630eb3ufd860df393ef05f5@mail.gmail.com>
Date: Fri, 22 Jun 2007 14:59:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706221219.16243.yinghai.lu@sun.com>
	 <20070622193124.GG5051@rhun.smartcity.com>
	 <20070622213327.69663288@the-village.bc.nu>
	 <m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>
> For a normal kexec we should shut everything down before the kernel
> transition so it should not be an issue.
>
> YH do you think you can look at simply reserving a portion of the iommu?
> And having the kexec on panic kernel use the reserved portion?
>
two copy region: one for first kernel, and one for second kernel? it
should work.
first kernel is using [64M, 128M), and the second will get assign to
[64M,128M) again.
when it try to memset to clear that region it will cause restart.
in that region, only first 256K can not touched, even read. rest could
be accessed.

YH
