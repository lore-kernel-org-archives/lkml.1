Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbYEKNJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbYEKNJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 09:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYEKNJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 09:09:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:5662 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYEKNJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 09:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=M0EpsQSto6JW9pUtmXyJ5R4gRuFOeB8BkEU6aQy/dHKLJU7j6OG/fZvG2KIonq63inNwFHYBUMQKhF+22VZ8WHgVzFONk+uupJw3OLcyotWCN8rDxMRNWEteig2gYMpeBw83uzT/A9LQw+1Bjb954RZfjr51swh1AkB40Ubo42A=
Message-ID: <19f34abd0805110609lf3180dm3b1078e373983ad7@mail.gmail.com>
Date: Sun, 11 May 2008 15:09:28 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Error in save_stack_trace() on x86_64?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am having a problem with v2.6.26-rc1 on x86_64. It seems that
save_stack_trace() is not able to follow page fault boundaries, since
all my saved traces look like this:

RIP: 0010:[<ffffffff8039b004>]  [<ffffffff8039b004>] add_uevent_var+0xb4/0x160
    ...
 [<ffffffff80221f97>] kmemcheck_read+0x127/0x1e0
 [<ffffffff80222269>] kmemcheck_access+0x179/0x1d0
 [<ffffffff8022231f>] kmemcheck_fault+0x5f/0x80
 [<ffffffff8061cd1e>] do_page_fault+0x4de/0x8d0
 [<ffffffff8061a7d9>] error_exit+0x0/0x51
 [<ffffffffffffffff>] 0xffffffffffffffff

I have this in my .config:

CONFIG_STACKTRACE_SUPPORT=y
CONFIG_STACKTRACE=y
...
CONFIG_FRAME_POINTER=y
...
CONFIG_DEBUG_INFO=y


On 32-bit, I am able to see the calls leading up to the page fault as
well. Did I miss something here?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
