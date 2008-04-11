Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbYDKIV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbYDKIV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbYDKIVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:21:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:61116 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbYDKIVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:21:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EJqxmYG2TnYP/OuRNS9ej7VBWaed+3pNhSEaumvOZA+FHhgEHhrOBZzfCVPeMF0O5SFcrQJ5s2MTDdDcx4XQK3+SRk2V63ifPUk1yUMmFjZmNSvGwJ3X11Z5BDQKtxHrWQO0t3GH+PlxX5IM9AX/CzODLEzSAsi/1NJPhsnnKtU=
Message-ID: <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com>
Date: Fri, 11 Apr 2008 11:21:09 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
Cc: linux-kernel@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>,
       "Mel Gorman" <mel@csn.ul.ie>, "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080411074145.GA4944@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080411074145.GA4944@elte.hu>
X-Google-Sender-Auth: 82923d80cbc5a16b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Apr 11, 2008 at 10:41 AM, Ingo Molnar <mingo@elte.hu> wrote:
>  our x86.git randconfig auto-qa found a mm/slab.c early-bootup crash in
>  mainline that got introduced since v2.6.24.
>
>   http://redhat.com/~mingo/misc/log-Thu_Apr_10_10_41_16_CEST_2008.bad
>   http://redhat.com/~mingo/misc/config-Thu_Apr_10_10_41_16_CEST_2008.bad
>
>  Note, the very same bzImage does not crash on other testboxes - only on
>  this 8-way box with 4GB of RAM.
>
>  i tried a "use v2.6.24's slab.c" revert (with a few API fixes needed for
>  it to build on .25) but that didnt solve the problem either.

As mentioned privately, I suspect it's the page allocator changes that
went into 2.6.24. Mel, Christoph, any ideas?
