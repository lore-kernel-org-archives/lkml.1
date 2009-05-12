Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbZELAuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbZELAuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbZELAuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:50:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36517 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZELAup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:50:45 -0400
Message-ID: <4A08C79C.5090501@zytor.com>
Date: Mon, 11 May 2009 17:49:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: Addition of cpufeatures to friendly access
 miscellaneous MSRs
References: <1242058494.5139.7.camel@ht.satnam>  <4A086B58.30607@zytor.com> <1242088979.2504.13.camel@ht.satnam>
In-Reply-To: <1242088979.2504.13.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> 
> The basic point of these patchset is to friendly access miscellaneous
> MSRs in kernel and userspace.
> 
> Some of these patches are using hardware cpufeature and others are
> software.
> 
> In kernel some of these MSRs are frequently used and doing checking
> before accessing these MSR in various places.
> 
> So I think it will be right approach to check in one place and set
> related cpufeature and in other places we only need to check cpufeature
> and then access MSR.
> 
> This patchset is only adding cpufeature. I will release accessing
> cpufeatures in upcoming series.
> 

For those that have in-kernel users, this is fine (and valid), but this 
is the wrong order in which to do things, since you patchset doesn't 
verify where those happen.  Rather, it's better to follow each 
cpufeature with its users rather than a batch of producers followed by a 
set of consumers.

Note: I do *not* consider debugfs only consumers to be valid in this 
context.

	-hpa

