Return-Path: <linux-kernel-owner+w=401wt.eu-S1031735AbXHMNu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031735AbXHMNu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938205AbXHMKZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:25:23 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4473 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936278AbXHMKZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:25:18 -0400
Message-ID: <46C03166.1000301@shadowen.org>
Date: Mon, 13 Aug 2007 11:24:38 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: jschopp <jschopp@austin.ibm.com>, rdunlap@xenotime.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Make checkpatch warn about pointless casting of kalloc returns.
References: <20070808024321.GA6316@redhat.com> <46B9F7C9.9060406@austin.ibm.com>
In-Reply-To: <46B9F7C9.9060406@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jschopp wrote:
>> +# check for pointless casting of kmalloc return
>> +        if ($rawline =~ /\*\)[ ]k[czm]alloc/) {
> 
> It looks to me like this will catch
> 
> foo = (char *) kmalloc(512);
> 
> but not
> 
> for = (char* )kmalloc(512);
> 
> I haven't tried it but how about something like:
> 
> if($rawline =~/\(.*\)\s*k[czm]alloc/){
> 
> which if I got it right should match the typecast with any combination
> of spacing.
> 
>> +            WARN("No need to cast return value.\n");
> 
> Could the warning be more descriptive?  This describes what, but it
> should also describe why; after all if somebody made this error they may
> not know they why.

Yes there are a few problems with the match, plus it needs to be on the
processed line to avoid false matches in strings (however unlikely).  I
ended up with the following:

                if ($line =~ /\*\s*\)\s*k[czm]alloc\b/) {
                        WARN("unnecessary cast may hide bugs, see
http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
                }

Which just fits on the line :).

Thanks for the patch.  Will be in 0.10 coming to an -mm near you soon.

-apw
