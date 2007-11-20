Return-Path: <linux-kernel-owner+w=401wt.eu-S1763287AbXKTCSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763287AbXKTCSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762909AbXKTCQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:16:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47634 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762910AbXKTCQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:16:45 -0500
Message-ID: <4742435F.6010803@zytor.com>
Date: Mon, 19 Nov 2007 18:15:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 37/45] x86_64: Support for fast per cpu operations
References: <20071120011132.143632442@sgi.com> <20071120011340.569486037@sgi.com> <47423FB7.20800@zytor.com> <Pine.LNX.4.64.0711191802270.19954@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711191802270.19954@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Mon, 19 Nov 2007, H. Peter Anvin wrote:
> 
>> There was, at some point, discussion about using the gcc TLS mechanism, which
>> should permit even better code to be generated.  Unfortunately, it would
> 
> How would that be possible? Oh. You mean the discussion where I mentioned 
> using the thread attribute?
> 
>> require gcc to be able to reference %gs instead of %fs (and vice versa for
>> i386), which I don't think is available in anything except maybe the most
>> cutting-edge version of gcc.
> 
> Right. That is why we do it in ASM here.
> 
>> However, if we're doing a masssive revampt it would be good to get an idea of
>> how to migrate to that model eventually, or why it doesn't make sense at all.
> 
> If you can tell me what the difference would be then we can discuss it. 
> AFAICT there is no difference. Both use a segment register.
> 

As far as I can tell from a *very* brief look at your code (which means 
I might have misread it), these are the differences:

- gcc uses %fs:0 to contain a pointer to itself.
- gcc uses absolute offsets from the thread pointer, rather than adding
   %rip.  The %rip-based form is actually more efficient, but it does
   affect the usable range off the base pointer.

	-hpa
