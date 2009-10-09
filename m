Return-Path: <linux-kernel-owner+w=401wt.eu-S934420AbZJIVQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420AbZJIVQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761418AbZJIVQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:16:37 -0400
Received: from claw.goop.org ([74.207.240.146]:42643 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761416AbZJIVQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:16:35 -0400
Message-ID: <4ACFA80E.7050701@goop.org>
Date: Fri, 09 Oct 2009 14:15:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Duplication of vdso and vsyscall code?
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/vsyscall_64.c implements vgettimeofday and vgetcpu. 
(And vtime)

arch/x86/vdso/vclock_gettime.c implements __vdso_gettimeofday (and
__vdso_clock_gettime), and vgetcpu.c has __vdso_getcpu.

These appear to be functionally identical duplicate definitions.   I
don't understand the history here to know how we came to get two sets of
these functions, but surely we can share the same code for both of these?

Thanks,
    J
