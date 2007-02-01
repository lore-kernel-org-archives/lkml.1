Return-Path: <linux-kernel-owner+w=401wt.eu-S1422833AbXBAXP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422833AbXBAXP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 18:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422775AbXBAXP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 18:15:58 -0500
Received: from old-tantale.fifi.org ([64.81.251.130]:33140 "EHLO
	tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422837AbXBAXP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 18:15:56 -0500
To: Denis Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: O_NONBLOCK setting "leak" outside of a process??
References: <200701272152.11087.vda.linux@googlemail.com>
	<87bqkhuqpp.fsf@tantale.fifi.org>
	<200702020000.40524.vda.linux@googlemail.com>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 01 Feb 2007 15:15:53 -0800
In-Reply-To: <200702020000.40524.vda.linux@googlemail.com>
Message-ID: <87abzxbhau.fsf@tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Vlasenko <vda.linux@googlemail.com> writes:

> What share the same file descriptor? MC and programs started from it?

All the processes started from your shell share at least fds 0, 1 and 2.
 
> I thought after exec() fds atre either closed (if CLOEXEC) or
> becoming independent from parent process
> (i.e. it you seek, close, etc your fd, parent would not notice that).
> 
> Am I wrong?

I'm afraid so.  Seek position and flags are still shared after an
exec.

Phil.
