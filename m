Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYKTRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYKTRqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYKTRqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:46:08 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:31716 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYKTRqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:46:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YAUiAg41qf4xOo8pWwCKEerL4CBQC0CMxeieqhA1wh+5h1+Nc2TtGMGy98hr5nmc5i
         TcLg86SQ1AtfYLqKeKBLlIrmL1SNCKV0mHNN2/pAl4aaA7iXP+ggUdFxcy09fF/curfa
         6ssXZf2ZFq4QFE5SVQ+g3hdgTqIxaU3P0eqsI=
Message-ID: <87a5b0800811200946m4b58db6aoe91bfc45c38982bb@mail.gmail.com>
Date: Thu, 20 Nov 2008 17:46:04 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Tim Bird" <tim.bird@am.sony.com>
Subject: Re: [PATCH] init/main.c: Use ktime accessor function in initcall_debug code.
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4925A0BC.7050207@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87a5b0800811200647t4de76a2ah683ac6083014d061@mail.gmail.com>
	 <4925A0BC.7050207@am.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 5:39 PM, Tim Bird <tim.bird@am.sony.com> wrote:
> Will Newton wrote:
>> The initcall_debug code access the tv64 member of ktime. This won't work
>> correctly for large deltas on platforms that don't use the scalar ktime
>> implementation.
>
> In principle I see no problem with this.  But as a matter of
> practice it may be overkill.

Possibly, but it makes the code clearer I think.

> How big does the delta have to be for this to be a problem?
> And how much overhead does ktime_to_ns() add?

Deltas over a second will be incorrect. I have serial8250_init taking
8 seconds at the moment, so that isn't unheard of.

On scalar ktime architectures it should be zero, on others a multiply
and an add (it's an inline). I wouldn't call it a fast path though.

>  -- Tim
>
> =============================
> Tim Bird
> Architecture Group Chair, CE Linux Forum
> Senior Staff Engineer, Sony Corporation of America
> =============================
>
>
