Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbXJCOTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbXJCOTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbXJCOTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:19:24 -0400
Received: from [122.1.235.145] ([122.1.235.145]:52439 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbXJCOTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:19:23 -0400
To: a.p.zijlstra@chello.nl
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200710032024.DJF78662.FHOLtMSFOOFJVQ@I-love.SAKURA.ne.jp>
	<20071003.204356.05853536.yoshfuji@linux-ipv6.org>
	<Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
	<200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
	<1191417864.5599.2.camel@lappy>
In-Reply-To: <1191417864.5599.2.camel@lappy>
Message-Id: <200710032319.ABF69743.VJQMLHFOFOtFOS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 3 Oct 2007 23:19:20 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thank you for pointing out.

Peter Zijlstra wrote:
> > Currently, TOMOYO Linux avoids read_lock, on the assumption that
> > (1) First, ptr->next is initialized with NULL.
> > (2) Later, ptr->next is assigned non-NULL address.
> > (3) Assigning to ptr->next is done atomically.
>  (4) wmb after asigning ptr->next
>  (5) rmb before reading ptr->next
Excuse me, but I didn't understand why (4) and (5) are needed.

append_function() {

  down(semaphore_for_write_protect);
  ...
  ptr = head;
  while (ptr->next) ptr = ptr->next;
  ptr->next = new_entry;
  ...
  up(semaphore_for_write_protect);

}

read_function() {

  for (ptr = head; ptr; ptr = ptr->next) {
    ...
  }

}

Are (4) and (5) needed even when (3) is exclusively protected by down() and up() ?

Regards.

