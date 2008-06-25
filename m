Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbYFYRLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbYFYRLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 13:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYFYRLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 13:11:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:3914 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYFYRLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 13:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZVcS77KBiYH05qN0GWZ7aCoi/2Xm9YG/hfF+izwLUjmYCR3oUMSywdOJbrjEAJ5AFp
         GkIoOTo0+P9gwz2DozmzYRfkJPmjhJe+UDA43qGny4jPuSIc72P7Oly0NKdMFDX9cAlu
         guLGQ2kUKKwAmlGkQWLlzhRsptOztRixL7wsc=
Message-ID: <19f34abd0806251011t6732e64dj43f4a67ec3de33ce@mail.gmail.com>
Date: Wed, 25 Jun 2008 19:11:11 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] softlockup: show irqtrace
Cc: "Johannes Weiner" <hannes@saeurebad.de>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <20080625160016.GA24967@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080625071323.GA7987@damson.getinternet.no>
	 <20080625160016.GA24967@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/08, Ingo Molnar <mingo@elte.hu> wrote:
> > (Compile tested on allyesconfig, allnoconfig, allnoconfig + softlockup
> > debugging.)
>
> hm, that must have taken quite some time to do on your desktop, right?

Hm, no. I admit to having improved the process of compilation
somewhat; I compiled only the affected files, or in case a CONFIG
prevents a file from being built, the complete parent directory. I
find that this works well in practice; the compiler usually warns
about implicit declarations (which would otherwise show up as linker
errors), so there is no need to link everything. (Sadly, this is not
true when declarations are provided regardless of definition -- I
think this is actually a case against putting declarations outside
#ifdefs.)

> FYI, there's no mandatory need to go through that buerocratic testing
> hassle with patches submitted to -tip - especially with small patches
> that look obvious and have a high chance of being right. We do non-stop
> allyes/allno/allmod+randconfig 64-bit/32-bit build and boot testing for
> every single patch added to the repository.
>
> Building, booting and testing it in the environment where you expect it
> to be used primarily should be more than enough.

Well, it's still somewhat emberassing to submit patches that don't compile :-)

This patch was also a typical error scenario; I introduce the call of
a function which requires the inclusion of a new header, one which
seemingly depends on a particular config option (lockdep). So I simply
wanted to be sure myself -- and then I might as well put it in the
e-mail. That also implicitly means that I did not boot test it at all.
(Because, yeah, what it actually DOES should be fairly obvious.)

Thanks, though! It's really nice to know the world's not coming to an
end because of a broken patch ;-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
