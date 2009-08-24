Return-Path: <linux-kernel-owner+w=401wt.eu-S1751715AbZHXGTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbZHXGTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbZHXGTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:19:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:56233 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbZHXGTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:mime-version:content-type
         :content-disposition:user-agent:message-id;
        b=fRux8RAsY6/tdphMFnItQEEnH36sBwzb/bIoYZ8KdDXaDjEcCNoJFcvrTWZvIPnpqV
         jSeyaJOsUbossccu1Ly6Go6QzhApjGd8rIa0fEkCUQRM4+52DNTaqnAmIZroUn0cWkSG
         Fm7fi24acy9o1EW3le7k5x3znx8jcQiwAibmU=
Date: Sun, 23 Aug 2009 23:19:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: cancel_delayed_work and its use of del_timer_sync
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090824065111.A51D8526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

I noticed that you went back and forth on using del_timer() vs.
del_timer_sync() in cancel_delayed_work(), finally settling on using
del_timer_sync(). I must say that the fact that cancel_delayed_work()
might sleep (given that there exists cancel_delayed_work_sync) catches a
few drivers writers by surprise. Moreover it makes delayed works
unsuitable in cases when we do want to cancel (so we can reschedule)
work in an interrupt context.

My question is if sleeping in cancel_delayed_work can be avoided or if
it is possible to have a reschedule_delayed_work() taht would do a
"soft" cancel and [re]submit the work. In the use cases I am concerned
about we don't really care if work is not reliably cancelled, we just
need to be able to schedule it earlier if it has already been scheduled
for execution in some point in the future.

Thanks!

-- 
Dmitry
