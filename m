Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab0CAJSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:18:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab0CAJSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:18:33 -0500
Date: Mon, 1 Mar 2010 11:18:19 +0200
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, avi@redhat.com, mtosatti@redhat.com, zamsden@redhat.com
Subject: use of setjmp/longjmp in x86 emulator.
Message-ID: <20100301091819.GD16909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am looking at improving KVM x86 emulator. Current code does not
handle some special cases correctly (code execution from ROM, ins/outs
to/from MMIO) and many exception conditions during instruction emulation
are not handled correctly. There is a lot of code in emulator that is
there only for exception propagation. Using setjmp/longjmp will be very
beneficial here as exception condition during instruction execution
maps very naturally to setjmp/longjmp, so my question is what about
adding setjmp/longjmp implementation to the kernel, or alternatively,
if there is a fear that it can be abused, add it locally to emulator.c?
Note that instruction emulation is always done in process context.

--
			Gleb.
