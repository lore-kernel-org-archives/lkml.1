Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZBJBO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZBJBO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 20:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbZBJBOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 20:14:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:59103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbZBJBOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 20:14:47 -0500
Message-ID: <4990D4E3.1010109@kernel.org>
Date: Tue, 10 Feb 2009 10:14:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 08/11] x86: use asm .macro instead of cpp #define in entry_32.S
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <1234186798-16820-9-git-send-email-tj@kernel.org> <4990774E.5080206@goop.org>
In-Reply-To: <4990774E.5080206@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Feb 2009 01:14:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Tejun Heo wrote:
>> Impact: cleanup
>>
>> Use .macro instead of cpp #define where approriate.  This cleans up
>> code and will ease future changes.
>>   
> 
> I agree with this in principle - cpp macros are indeed very ugly - but
> in practise I've found asm macros to be very hard to work with.  When
> things go wrong, the gas error messages are completely useless (it only
> reports the error on the line where the macro was used, without any
> detail about where in the macro the problem lies), and as far as I know,
> there's no way to see the source with macros expanded.

Hmm... I originally did the conversion because I had some .if trick in
SAVE_ALL which got removed later.  Even after the removal, it
generally looked like a good idea as x86_64 asm was primarily using
.macro too.  I do like being able to see the post-processing output of
cpp too but for assembler disassembling the output often seem to give
enough clue, so I don't think it's a deal breaker.  So, lacking
decisive technical merit either way, I was aiming for consistency with
x86_64 (and I already had the patch in queue so...).

Ingo, what do you think?

Thanks.

-- 
tejun
