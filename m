Return-Path: <linux-kernel-owner+w=401wt.eu-S932729AbZLRUSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbZLRUSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbZLRUST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:18:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:54898 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbZLRUSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:18:18 -0500
Message-ID: <4B2BE348.207@kernel.org>
Date: Fri, 18 Dec 2009 12:17:12 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] x86: move range related operation to one file
References: <4B2B4C19.6010402@kernel.org> <4B2B4F85.5030901@kernel.org> <4B2BE1BF.60803@zytor.com>
In-Reply-To: <4B2BE1BF.60803@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 12/18/2009 01:46 AM, Yinghai Lu wrote:
>> +
>> +struct range {
>> +	u64   start;
>> +	u64   end;
>> +};
> 
> Okay, this does bring up two things that I have long griped about.
> 
> Firstly, I don't think this is the proper data structure.  Even worse,
> the range operations take *inclusive* ranges (e.g. 0x0000 to 0xffff is
> 64K, not 0x0000 to 0x10000).  It would be one thing if it only affected
> the internal representation, but as written, this is exposed through the
> interfaces, too.
> 
> As far as the choice of data structures, I have used in other places,
> with very good success, a data structure which looks like:
> 
> struct {
> 	u64	start;
> 	u32	attr;
> };
> 
> Note that there is no end: the end is always given by an end token.  The
> "attr" here was an e820 attribute (or 0 for no attribute), but the
> payload can be almost anything -- for a simple include/exclude it can
> just be boolean.
> 
> This data structures doesn't permit things like out-of-order ranges,
> overlapping ranges, and so on, and that's a good thing; it means the
> data structure itself can never be ambiguous, and the interfaces clean
> out most errors inherently.

yes here is we have [start, end] instead of [start, end)

those range operation is used for one purpose:
add several ranges, and subtract some other ranges, it will take out overlap between those two sets.
and leave out the range that could be used.

and it is array based...for early stage.

YH
