Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbYHVVFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbYHVVFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbYHVVFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:05:32 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:33121 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbYHVVFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:05:32 -0400
From: Junio C Hamano <gitster@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Petr Baudis <pasky@suse.cz>, Alan.Brunelle@hp.com,
       linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <48A36838.3050309@hp.com>
 <20080819124602.9e8e69f7.akpm@linux-foundation.org> <48AEDD3D.4060507@hp.com>
 <20080822092549.ddcb7e79.akpm@linux-foundation.org>
 <20080822171651.GP10544@machine.or.cz>
 <20080822105136.a8432875.akpm@linux-foundation.org>
Date: Fri, 22 Aug 2008 14:05:21 -0700
In-Reply-To: <20080822105136.a8432875.akpm@linux-foundation.org> (Andrew
 Morton's message of "Fri, 22 Aug 2008 10:51:36 -0700")
Message-ID: <7v7ia8ahgu.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 0D2CDF86-708E-11DD-8118-3113EBD4C077-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 22 Aug 2008 19:16:51 +0200
> Petr Baudis <pasky@suse.cz> wrote:
>
>> On Fri, Aug 22, 2008 at 09:25:49AM -0700, Andrew Morton wrote:
> ...
>> > urgh, it's irritating when git-bisect directs you to a merge commit - it
>> > hasn't done it for me for ages.
>> 
>> Hmm, but doesn't that happen only when it's actually really the merge
>> commit that introduces the bug? Both parents of the merge commit were
>> marked as good by the user, so...
>
> A merge commit doesn't contain any kernel changes?  It's the individual
> commits (aka "patches") which were in that merge which broke stuff. 
> Confused.
>
> We're trying to dive inside that merge commit to find out which of the
> real commits caused the regression.

You may find neither parents were buggy, but the result of the merge is.

A trivial example is when one branch changes the semantics of an existing
function and converts all the call sites to the updated semantics, while
the other branch adds a new call site that still relies on the old
behaviour of that function.  The merge most likely won't textually
conflict, and neither git merge nor quilt patch would report conflicts,
but the end result is that the new call site added by the latter branch
now gets an unexpected outcome from the function and can misbehave.  You
cannot blame the breakage to either branch for such a breakage.
