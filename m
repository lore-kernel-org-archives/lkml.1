Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbZLJNxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbZLJNxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbZLJNxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:53:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbZLJNxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:53:46 -0500
Message-ID: <4B20FD2C.1010804@suse.cz>
Date: Thu, 10 Dec 2009 14:52:44 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.9 Thunderbird/3.0b4
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/3] Replace kernel/timeconst.pl with kernel/timeconst.sh
References: <200912080317.08254.rob@landley.net> <200912080319.30679.rob@landley.net> <4B1FC621.8060500@suse.cz> <200912091740.43147.rob@landley.net>
In-Reply-To: <200912091740.43147.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.12.2009 00:40, Rob Landley wrote:
> On Wednesday 09 December 2009 09:45:37 Michal Marek wrote:
>> You're trying to avoid the build dependency on Perl. What about adding a
>> timeconst.h_shipped with the precomputed values from timeconst.pl:
> 
> Been there, done that.  My first patch (way back for 2.6.25) took that 
> approach:
> 
> http://landley.net/hg/hgwebdir.cgi/firmware/file/a791ca629d9c/sources/patches/linux-2.6.25-
> rc1-noperl.patch
> 
> But it turns out various non-x86 targets (such as ARM OMAP) allow HZ to be 
> specified by an entry field in the config file, into which the user can type a 
> range of numbers.  See this post from last year for details:
> 
> http://lists.impactlinux.com/pipermail/firmware-impactlinux.com/2008-
> December/000022.html
> 
> This is why reducing the perl version to just the precomputed constants 
> wouldn't work either.  (They're there so that you only need to install a 
> random cpan library when surprised by a build break on non-x86 machines.)

That's why I wrote

>> plus some makefile automagic to run the script iff the HZ value isn't
>> precomputed. Then you would only need Perl for exotic HZ configurations.

E.g. make it
...
#elif HZ == 1200
...
#else
#include "timeconst_custom.h"
#endif

and the makefile would run timeconst.pl to generate timeconst_custom.h
iff HZ is set to something arbitrary. I don't have a patch for that, but
I don't see a fundamental problem with such approach.

Michal
