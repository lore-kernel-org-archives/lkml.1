Return-Path: <linux-kernel-owner+w=401wt.eu-S941609AbXGTQi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941609AbXGTQi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933659AbXGTQiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:38:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:4222 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763227AbXGTQit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MRrtslQgPexlsoyAFRokiSZRXCC/awJWfG0XGRHSBmptqAOcjxoquLPJOm2QsnDJT/jDsZiIgSCeAqhYgbvu5k4vShMN4RsC5lc5InvAEjvJXECLqBu9gq7MueijBBhlFSbBVXIYEFJWcD1ib0uIuUlMWIG0lTjoe91nlp1xAMs=
Message-ID: <a36005b50707200938y2a62616euae6a04f7248421df@mail.gmail.com>
Date: Fri, 20 Jul 2007 09:38:49 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: Regression with sys_time() speedup patch
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <s5h1wf3gjz3.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <s5hps2nqg4w.wl%tiwai@suse.de> <20070720151213.GA32043@elte.hu>
	 <s5h1wf3gjz3.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Takashi Iwai <tiwai@suse.de> wrote:
> But, is it safe to introduce another variable different from
> xtime.tv_sec?  Since xtime.tv_sec is referred in many other places,
> I'm afaid this may bring confusion...

Perhaps not if they are changed.

Somewhere where I cannot find them right now I've seen some bug
reports where the use of different time sources also caused problems.
This is no new situation.  Whenever one case uses xtime and another
case recomputed the time we have a discrepancy and this lead to
user-observable problems.

If this new variable can be used throughout it might be the right
solution.  But then there is of course the question why we have xtime
in the first place.

If/When I find the bug reports I'll point Ingo to them.
