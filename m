Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbYGTJqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbYGTJqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 05:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbYGTJqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 05:46:23 -0400
Received: from ozlabs.org ([203.10.76.45]:45796 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbYGTJqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 05:46:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
Date: Sun, 20 Jul 2008 19:45:58 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <487B05CE.1050508@jp.fujitsu.com> <200807151750.12131.rusty@rustcorp.com.au> <487D738B.4070104@jp.fujitsu.com>
In-Reply-To: <487D738B.4070104@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <200807201945.58836.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2008 14:05:31 Hidetoshi Seto wrote:
> Hi Rusty,
>
> Rusty Russell wrote:
> > On Tuesday 15 July 2008 11:11:34 Hidetoshi Seto wrote:
> >> However we need to be careful that the stuck CPU can restart
> >> unexpectedly.
> >
> > OK, if you are worried about that race, I think we can still fix it...
>
> After having a relaxing day, once I said:
>  "I like your idea that if we did not want to do something on the stuck CPU
>   then treat the CPU as stopped."
> but now I noticed that the stuck CPU can harm what we want to do if it is
> not real stuck... ex. busy loop in a subsystem, and we want to touch the
> core of the subsystem exclusively.

No.  You aim for perfection, but there is no "right" answer other than "don't 
get your system into this mess".  Whatever we do is going to be an educated 
guess.  And guessing that there'll be no race is a very good guess indeed.

The scenario we are addressing is a stuck CPU and module load.  If we fail 
stop machine, module load fails.

That is why we should continue if we can.  It is also why the default timeout 
cannot be 0.  You can't turn this on once you notice there's a problem: it's 
too late.

If we don't want to handle this case, let's not apply any patch at all.
Rusty.

