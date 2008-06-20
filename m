Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbYFUAc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbYFUAc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 20:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYFUAcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 20:32:20 -0400
Received: from ruckus.brouhaha.com ([64.62.206.2]:35840 "EHLO
	ruckus.brouhaha.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbYFUAcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 20:32:19 -0400
X-Greylist: delayed 2258 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2008 20:32:19 EDT
Message-ID: <40921.64.62.206.10.1214006079.squirrel@ruckus.brouhaha.com>
Date: Fri, 20 Jun 2008 16:54:39 -0700 (PDT)
Subject: Any lightweight way for one thread to force another thread to 
     suspend execution?
From: "Eric Smith" <eric@brouhaha.com>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any method for one thread to force another thread to suspend
execution, then later let it resume, that is lighter weight than using
signals?  I don't need it to be portable to anything other than Linux.
The suspend needs to be synchronous, but resume doesn't.

What I've thought about so far (but haven't tested) for thread A
to suspend thread B is to use a signal and two pthread conditions:

    Thread A                   Thread B
    -----------------------    -----------------------
    send signal to B

    wait on a cond 1

                               enter signal handler

                               signal cond 1

                               wait on cond 2

    wake up
    do stuff that needs
    thread B suspended

    signal cond 2

    continue                   wake up


Thanks for any suggestions!
Eric Smith

