Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbZCNHEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbZCNHEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 03:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZCNHEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 03:04:44 -0400
Received: from gw.goop.org ([64.81.55.164]:36454 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbZCNHEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 03:04:43 -0400
Message-ID: <49BB5708.1090604@goop.org>
Date: Sat, 14 Mar 2009 00:04:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: tip.git regression from "vsprintf: unify the format decoding layer
 for its 3 users"
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change fef20d9c1380f04ba9492d6463148db07b413708, "vsprintf: unify the 
format decoding layer for its 3 users", causes a regression in xenbus 
which results in no devices getting attached to a new domain.  Reverting 
fef20d9c1380f04ba9492d6463148db07b413708 and 
39e874f8afbdb3745e2406ce4ecbde9ac4cbaa78 fixes the problem.

I haven't identified what format string is being handled wrongly, so I 
don't know what the precise bug is.  The most complex looking format in 
use seems to be %.*s; there's also "%s/%s", "%i" and "%lX".

    J
