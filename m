Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYGNDiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYGNDiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 23:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbYGNDiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 23:38:06 -0400
Received: from [194.117.236.238] ([194.117.236.238]:56675 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbYGNDiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 23:38:06 -0400
Date: Mon, 14 Jul 2008 06:36:57 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: "Ryan Hope" <rmh3093@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: Performance Question: BUG_ON vs. WARN_ON_ONCE
Message-ID: <20080714063657.6d1fda18@linux360.ro>
In-Reply-To: <48f7fe350807131657v4b95340ajfaaacbb04eefa21f@mail.gmail.com>
References: <48f7fe350807131657v4b95340ajfaaacbb04eefa21f@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008 19:57:37 -0400
"Ryan Hope" <rmh3093@gmail.com> wrote:

> However, this causes the kernel to crash or oops under certain loads.
> Reverting this change makes the error go away. Is there any sort of
> performance difference between BUG_ON and WARN_ON_ONCE, I figure the
> change was for a reason so I am wondering what will result from this
> change. Any info would be appreciated.
> 
> -Ryan

Looks like WARN_ON_ONCE declares and uses a static int variable, so
it's not reentrant. It should be an atomic static. Still, I don't see
how this could crash the kernel or even oops, or have any other
side-effects.

Could you post the oops? Are you sure the oops you're seeing isn't just
what WARN_ON et al. regularly produce?


	Eduard
