Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0CCIjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 03:39:55 -0500
Received: from mail-bw0-f212.google.com ([209.85.218.212]:34930 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab0CCIjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 03:39:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=qNSmOVV1AEIP3SYaqD0JorpsEQMaOEUrF+8C6m3yXEYeqWMJpdw0yD77IX0HpeSro8
         nEOJAjlUKu+yzkU1TSFw+kEhiK8VbRMJcP/si3gWMcfsD4wGt9bRoYX9sO64C3r5CRVC
         DYbQMT+Kds2ZABrTVsHY0xNOwm6WxIMUKSxUo=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] blkdev: fix merge_bvec_fn return value checks
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
	<20100228184634.GI5768@kernel.dk> <874okyf4iw.fsf@openvz.org>
	<20100303073014.GE5768@kernel.dk>
Date: Wed, 03 Mar 2010 11:39:50 +0300
In-Reply-To: <20100303073014.GE5768@kernel.dk> (Jens Axboe's message of "Wed,
	3 Mar 2010 08:30:14 +0100")
Message-ID: <87zl2per3d.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Wed, Mar 03 2010, Dmitry Monakhov wrote:
>> Jens Axboe <jens.axboe@oracle.com> writes:
>> 
>> > On Sat, Feb 27 2010, Dmitry Monakhov wrote:
>> >> merge_bvec_fn() returns bvec->bv_len on success. So we have to check
>> >> against this value. But in case of fs_optimization merge we compare
>> >> with wrong value. This patch must be included in
>> >>  b428cd6da7e6559aca69aa2e3a526037d3f20403
>> >> But accidentally i've forgot to add this in the initial patch.
>> >> To make things straight let's replace all such checks.
>> >> In fact this makes code easy to understand.
>> >
>> > Agree, applied.
>> Ohh.. as you already know this patch break dm-layer. Sorry.
>> This is because dm->merge may return more than requested. So correct
>> check must test against less what requested. Correct patch attached.
>
> Have you tested this with dm and md (ie actual users of the merge_bvec
> functionality) this time?
Yes. This time both md and dm are ok.
