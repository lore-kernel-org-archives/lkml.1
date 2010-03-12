Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407Ab0CLPcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 10:32:12 -0500
Received: from mail-pz0-f200.google.com ([209.85.222.200]:61068 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934354Ab0CLPcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 10:32:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=oKHhdzVixpuDWHqGMI2357OpbzOl3rqzPYMwiXG0cV981Nyrwd4QrDyRnHAllJO5bR
         r3rgv8L3Z0YhERf97a+oaEsFcxPFYJxWySyjjDx+KCW8/RPExeaqjonlZpeKsELUsl05
         FSebYjf3URj3TgpqzNWnejvMEkeXkZ7xvNnas=
MIME-Version: 1.0
Date: Fri, 12 Mar 2010 10:32:04 -0500
X-Google-Sender-Auth: a74a205840ba3d72
Message-ID: <40ec3ea41003120732w5f44a2ebq728047e742f32bba@mail.gmail.com>
Subject: Using tracing_off() in __schedule_bug()
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-kernel@vger.kernel.org, kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're considering using tracing_off() in __schedule_bug() in the
Ubuntu kernel to help us solve "scheduling while atomic" bugs without
needing to compile and install a special kernel to do so. Using the
tracing_off() call enables us to generate smaller function traces when
debugging, and find the bug easier since it should be at the end of
any traces. The patch we are thinking of using can be found at [1].
You can find an overview of how bugs are solved using this approach
there as well.

Are there any thoughts as to the appropriateness of this patch in
Ubuntu kernels? My guess is that this isn't done in the upstream
vanilla kernels because it would be annoying to have a stock kernel
littered with tracing_off() calls if you hit one when you weren't
meaning to. However, we're interested in hearing if there's some
negative consequence we haven't thought of.

Thanks,
Chase Douglas

[1] http://lkml.org/lkml/2009/4/10/310
