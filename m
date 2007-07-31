Return-Path: <linux-kernel-owner+w=401wt.eu-S933288AbXGaV0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288AbXGaV0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbXGaV0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:26:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:46528 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbXGaV0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EUZhv6IVqjmewXQbTv00kyzaGNkifRZydL+KYKOWb4ZgTzImwU2R3l/LxH4YR7Z3O8lXyrOyIa0Df90g1ayC3vtRNpWsvbMWS2l8RB0kqgk7k0UJ6JwDWD5K8m7yc0wC+6fsiQlmyj2T392Lhiqlw7wsblhCyRPYeo0CPwI/WVU=
Message-ID: <ab08258e0707311426r32dc15cexb6867648bc6a45a4@mail.gmail.com>
Date: Tue, 31 Jul 2007 14:26:33 -0700
From: "Haifeng He" <hehaifeng2nd@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Load interrupt code dynamically
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

I am working on a project to reduce the memory requirement of Linux
kernel code. The idea is to keep infrequent executed code on disk and
load them into a
buffer (code buffer) in memory at runtime. The idea is simple but
there are many issues
dealing with the concurrency in the kernel. Interrupt is one of them.

Since interrupt is executed asynchronously, my current solution is to
assign two buffers: one for regular (non-interrupt code) and one
specifically for
interrupt code. However, the scheme still does not work well. The
problem is that, it seems,
there can multiple interrupt occur at the same in the kernel and
therefore, if interrupt
A is using the code buffer, another interrupt B can be issued and
overwrite the code
buffer(where A's code is stored). I found couples of such examples,
including, driver code
for ide (driver/ide/) and video (driver/video/vgacon.c) and console
(driver/char/). My
feeling is that since handling ide interrupt may take a while, kernel
will enable
other interrupts when handling an ide request.

My first question is, what are other interrupts in the kernel that can
allow other interrupts
to be issued? Second question is, how does the kernel switch between
different interrupts? Last, any suggestion on how to change my current
implementation to
enable loading interrupt code dynamically?

Thank you

Haifeng
