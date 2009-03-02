Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZCBXmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZCBXmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZCBXm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:42:29 -0500
Received: from n74.bullet.mail.sp1.yahoo.com ([98.136.44.186]:33377 "HELO
	n74.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752758AbZCBXm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:42:29 -0500
X-Yahoo-Newman-Id: 282741.20490.bm@omp415.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aU+HBgjA9LVxXvmFppE13ZtzIsFdBCwXV3nG6QPnHYzodf49l2jn+YeorK7QfOcJQlmV/MHyes1Mee4Amfq1uobPRiThzIDegWgKO0Ml9IhruBL2hBG4rAgH83Yc5pyunCSBdYR3jMTQOWmL0jh1tI3nnNpnp9cquFlsajR2dRE=  ;
X-YMail-OSG: YVoE4.gVM1kR6A1v2t8lKWin5ThjZTp3v3bRkS_czKu4P8crc.dLUcti6GWp9BXVepoDSsJx6k2OJXMPmSelpjkbUiN3SvmgY6nH3u2bme11Ki9hOInEcKjBEGstgV5wYwwK_Z5msrswf4b_hyEH3MoK
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Mon, 2 Mar 2009 15:42:24 -0800
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021520.30826.david-b@pacbell.net> <20090302232650.GA14515@elte.hu>
In-Reply-To: <20090302232650.GA14515@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021542.25153.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Ingo Molnar wrote:
> If you want to work on genirq threaded IRQ handlers them please 
> check out and test the threaded IRQ handlers patches that are 
> being worked on at lkml. See:
> 
> [patch 0/4] genirq: add infrastructure for threaded interrupt handlers V2

I did check them out, as noted earlier in this thread.

The significant omission is lack of support for chaining
such threads.  Example, an I2C device that exposes
several dozen IRQs with mask/ack/... operations that
require I2C access.

I'm not sure what Thomas intends to do with that issue,
if anything.  It does touch on messy bits of genirq.

Those V2 patches do look to handle simple cases well,
of the flavor that's often handled today by creating
a singlethreaded workqueue in the driver.  I think
it's good to have such support, but that's not enough
to handle the hardware I've come across.

- Dave

