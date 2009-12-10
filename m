Return-Path: <linux-kernel-owner+w=401wt.eu-S1760950AbZLJQHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950AbZLJQHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZLJQG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:06:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50841 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbZLJQG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:06:58 -0500
Date: Thu, 10 Dec 2009 17:06:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, yinghai@kernel.org
Subject: Re: Bisected regression (Was Re: current -git fails to boot on
 nehalem-ex)
Message-ID: <20091210160640.GB27794@elte.hu>
References: <20091210091040.GG8742@kernel.dk>
 <20091210103945.GI8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210103945.GI8742@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Dec 10 2009, Jens Axboe wrote:
> > Hi,
> > 
> > As written in the subject, it just hard hangs before writing anything on
> > the console. With earlyprintk, I captured the failure, see below.
> > 
> > I'll try and bisect this, but it takes some time (since the bios and
> > post process takes forever). I just updated the firmware on the box as
> > well, but it did boot 2.6.32 (and RHEL5 boots fine too). Of course that
> > doesn't rule out a BIOS bug.
> 
> Results are persistent, git bisect points to:
> 
> commit b24c2a925a9837cccf54d50aeac22ba0cbc15455
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Tue Nov 24 02:48:18 2009 -0800
> 
>     x86: Move find_smp_config() earlier and avoid bootmem usage
> 
> which appears consistent with the panic(). Reverting that does indeed
> make current -git boot properly.

Thanks. Yinghai, do you have any ideas, or should we revert it?

	Ingo
