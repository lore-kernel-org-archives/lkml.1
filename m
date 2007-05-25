Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbXEYKJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbXEYKJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 06:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbXEYKJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 06:09:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:44159 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbXEYKJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 06:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LgS+hiSB4dMBJS97N3RvJbfr3dPw6KDbsQGysAb8helOc8l0lI+vgNE0hnCZFqRQWVTijwdkmqibZvSB8+prsra9Zyk+LxObS0Jh3EzySzFFsQ9RJ/xQakuJK0s3q5MRDSjMc6gw0lKd+jWzTT8IIobh+RiZT+9Gf8Kk7gLCunE=
Message-ID: <ba1ee50c0705250309j64eb1d99j45b1ed35a4a5b1ed@mail.gmail.com>
Date: Fri, 25 May 2007 05:09:30 -0500
From: "Daniel Newby" <daniel.a.newby@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: how to allow board writers to customize driver behavior (watchdog here)
In-Reply-To: <20070525040445.GA8395@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com>
	 <200705240929.51696.rgetz@blackfin.uclinux.org>
	 <20070524152318.GA4491@linux-sh.org>
	 <200705241332.30335.rgetz@blackfin.uclinux.org>
	 <20070525040445.GA8395@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Paul Mundt <lethal@linux-sh.org> wrote:
> So far the only example anyone has provided outside of periodic timers or
> hardware reset has been dumping the stack when something gets stuck.
> Softlockup does this already today, using a timer.

Many watchdogs can be hooked up to a non-maskable interrupt (NMI) that
cannot be disabled or preempted.  You get a stack dump even for drastic
bugs:  ISR lock up, timer misconfiguration, level-sensitive interrupt
line stuck asserted, and so forth.  Getting that information by other
means can be painful and/or expensive.

The Blackfin chip in the original message appears to support watchdog
NMI.

    -- Daniel
