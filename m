Return-Path: <linux-kernel-owner+w=401wt.eu-S934807AbXFFSgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934807AbXFFSgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760441AbXFFSgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:36:12 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3378 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571AbXFFSgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:36:11 -0400
Message-ID: <4666FE8F.6050005@shadowen.org>
Date: Wed, 06 Jun 2007 19:35:59 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add a trivial patch style checker v2
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <735b25fd823d649f9cf55b63eb878b63@pinky> <Pine.LNX.4.62.0706061433430.10542@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0706061433430.10542@pademelon.sonytel.be>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Tue, 29 May 2007, Andy Whitcroft wrote:
>> As a first step package up the current state of the patch style
>> checker and include it in the kernel tree.  Add instructions
>> suggesting running it on submissions.  This adds version v0.01 of
>                                                            ^^^^^
>> the checkpatch.pl script.
>>
>> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
>> ---
>> 	Ok, here is V2 of the checker.	A lot of feedback has been
>                     ^^
>> --- /dev/null
>> +++ b/scripts/checkpatch.pl
>> @@ -0,0 +1,595 @@
>> +#!/usr/bin/perl -w
>> +# (c) 2001, Dave Jones. <davej@codemonkey.org.uk> (the file handling bit)
>> +# (c) 2005, Joel Scohpp <jschopp@austin.ibm.com> (the ugly bit)
>> +# (c) 2007, Andy Whitcroft <apw@uk.ibm.com> (new conditions, test suite, etc)
>> +# Licensed under the terms of the GNU GPL License version 2
>> +
>> +use strict;
>> +
>> +my $P = $0;
>> +
>> +my $V = '0.01';
>             ^^^^
> So, what's the correct version number? ;-)
> 

Yep that is terribly confusing.  Internally I have actually tagged the
V2 version 0.02, and will be using those numbers from now on.

> Will http://www.codemonkey.org.uk/projects/checkpatch/checkpatch.git/ (hey, a
> project with the same name started by the same person???) be merged in?
> 
> Below is a small fix for the wrong hardcoded script name

Yep this looks good.  I've squished this into my tree.

> 
> ---
> Subject: [PATCH] Fix checkpatch.pl name in usage template
> 
> Fix checkpatch.pl name in usage template:
>   - Don't use wrong hardcoded script name
>   - Strip dirname from command name
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> ---
>  scripts/checkpatch.pl |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -7,6 +7,7 @@
>  use strict;
>  
>  my $P = $0;
> +$P =~ s@.*/@@g;
>  
>  my $V = '0.01';
>  
> @@ -26,7 +27,7 @@ GetOptions(
>  my $exit = 0;
>  
>  if ($#ARGV < 0) {
> -	print "usage: patchstylecheckemail.pl [options] patchfile\n";
> +	print "usage: $P [options] patchfile\n";
>  	print "version: $V\n";
>  	print "options: -q           => quiet\n";
>  	print "         --no-tree    => run without a kernel tree\n";

-apw
