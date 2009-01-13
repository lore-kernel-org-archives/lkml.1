Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbZAMXj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbZAMXj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbZAMXjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:39:45 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:54036 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZAMXjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:39:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=TqZzEZFooqk0nVageYSQcBxvEoikWJMsA5oZPEVj04CewSkysu1lJnAOa0za3F0j87
         qvfMsZim5aVgiM7TRofYReXtOtPdybwAHc2UWbnwjogDpOpkOd/ekXyHb79moZ5rEjr0
         MYHneJCbiBBe1ouFGcerXju9DdT3kMPykYmf4=
From: Nelson Castillo <arhuaco@freaks-unidos.net>
Subject: [PATCH 0/5][RFC] Touchscreen filters
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, andy@openmoko.com
Date: Tue, 13 Jan 2009 18:39:30 -0500
Message-ID: <20090113233743.26361.14313.stgit@fugue.noexisteestedominiotanlargo.biz>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements a solution for a problem
we have: lots of noise in the touchscreen of the Openmoko
Neo1973/FreeRunner. This is the result of teamwork.

We are using a small touchscreen filtering framework
in kernel space for the S3C2410/S3C2442 touchscreen
controllers. The filters can be used by other drivers as
well (we have noticed a few drivers include averaging and some
other custom filters).

We do not want to port tslib to kernel space. The big
difference is that in tslib you cannot give feedback to an
interrupt handler. tslib does what it can, but we have the
power in kernel space to do better.

With the current implementation we try to get as many points
as we need to in order to provide a clean input event that
does not need further user-space mangling. If we fail to get
a valid point after some time we just ignore the event. In
our tests this approach has been performing very well. Some
of us think it would be nice if a program can gather clean
touchscreen data from /dev/inputX.

Here is a document that explains the filters with links to
source code that lives in our GIT repository and some videos
The videos are not polished but they illustrate what we
wish to show.

  https://wiki.openmoko.org/wiki/Touchscreen_Filters

We hope this work is suitable for mainline inclusion.

We will be waiting for your comments.

Thanks,
Nelson, on behalf of all who contributed to what is proposed in this email.

 drivers/input/touchscreen/Kconfig            |   44 +++++
 drivers/input/touchscreen/Makefile           |    5 +
 drivers/input/touchscreen/ts_filter.c        |   64 ++++++++
 drivers/input/touchscreen/ts_filter_group.c  |  221 ++++++++++++++++++++++++++
 drivers/input/touchscreen/ts_filter_linear.c |  178 +++++++++++++++++++++
 drivers/input/touchscreen/ts_filter_mean.c   |  172 ++++++++++++++++++++
 drivers/input/touchscreen/ts_filter_median.c |  215 +++++++++++++++++++++++++
 include/linux/ts_filter.h                    |   56 +++++++
 include/linux/ts_filter_group.h              |   39 +++++
 include/linux/ts_filter_linear.h             |   64 ++++++++
 include/linux/ts_filter_mean.h               |   34 ++++
 include/linux/ts_filter_median.h             |   36 ++++
 12 files changed, 1128 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/ts_filter.c
 create mode 100644 drivers/input/touchscreen/ts_filter_group.c
 create mode 100644 drivers/input/touchscreen/ts_filter_linear.c
 create mode 100644 drivers/input/touchscreen/ts_filter_mean.c
 create mode 100644 drivers/input/touchscreen/ts_filter_median.c
 create mode 100644 include/linux/ts_filter.h
 create mode 100644 include/linux/ts_filter_group.h
 create mode 100644 include/linux/ts_filter_linear.h
 create mode 100644 include/linux/ts_filter_mean.h
 create mode 100644 include/linux/ts_filter_median.h

