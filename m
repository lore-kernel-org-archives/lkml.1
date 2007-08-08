Return-Path: <linux-kernel-owner+w=401wt.eu-S936333AbXHHRGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936333AbXHHRGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936570AbXHHRFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:05:21 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60866 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936477AbXHHRFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:05:20 -0400
Message-ID: <46B9F7C9.9060406@austin.ibm.com>
Date: Wed, 08 Aug 2007 12:05:13 -0500
From: jschopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, apw@shadowen.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Make checkpatch warn about pointless casting of kalloc returns.
References: <20070808024321.GA6316@redhat.com>
In-Reply-To: <20070808024321.GA6316@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +# check for pointless casting of kmalloc return
> +		if ($rawline =~ /\*\)[ ]k[czm]alloc/) {

It looks to me like this will catch

foo = (char *) kmalloc(512);

but not

for = (char* )kmalloc(512);

I haven't tried it but how about something like:

if($rawline =~/\(.*\)\s*k[czm]alloc/){

which if I got it right should match the typecast with any combination of spacing.

> +			WARN("No need to cast return value.\n");

Could the warning be more descriptive?  This describes what, but it should also describe 
why; after all if somebody made this error they may not know they why.
