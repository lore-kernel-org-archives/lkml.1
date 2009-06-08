Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbZFHX2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbZFHX2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZFHX2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:28:18 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:54918 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbZFHX2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pCP9olGW8w6ih/YrXAvrM8JQSCmbg2MZXz214AOXXOF30tGkq8SRwz3ew9JZhL68Wx
         8zKhVAiSQqG5CYRfC2tr2CzKUuaNJPKLblTvIP0sXqnb0RO2ITzajJoYXX+NYGFpj6Xf
         XdbMVP6ecotR/KyEF437n5veYFbKPkCyuQa1U=
MIME-Version: 1.0
Date: Mon, 8 Jun 2009 19:28:19 -0400
Message-ID: <8bd0f97a0906081628o7d30e05ld961c00a690c140d@mail.gmail.com>
Subject: adding lockdep support to the Blackfin arch
From: Mike Frysinger <vapier.adi@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ive been extending the Blackfin arch recently to support lockdep.
since i also had to implement irqflags/stacktrace as well, i wouldnt
be surprised if this issue is nested in there, plus this is a no-mmu
system.

at any rate, when i boot up a Blackfin system with PROVE_LOCKING
enabled, i end up with this warning:
Badness at kernel/fork.c:988

which correlates to this in copy_process():
    DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);

btw, in order to get this to work in the first place, i had to extend
-mike
