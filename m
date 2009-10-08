Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbZJHONM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbZJHONM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 10:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbZJHONM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 10:13:12 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:41780 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbZJHONL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 10:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=LbxAHALUrPyzCWSsSWgtiNL6ICNJ9GkRasYA00OghnCk+r9/Q1TDwLovnaf2O89xvG
         O5zv1bBciwi1EEy2b5N2lVMiJtD+jshnZF1eZCCOvbLUvRlfO7RAd862Yzhbb220QD+R
         caNUy3LwHVgpbEhbtkuo7GlM/ot7hzyJs9W8w=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
Date: Thu, 8 Oct 2009 16:12:33 +0200
Message-ID: <7c86c4470910080712v730a4c7fxbd71d97b605a1f6e@mail.gmail.com>
Subject: perf_events: issue with scaling information
From: stephane eranian <eranian@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


With libpfm4, I have developed a set of examples which are using
perf_events to demonstrate typical counting and sampling scenarios.

In two of the sampling program, it appears time_enabled, time_running
included in the samples are incorrect.

The program notify_self.c uses IOC_REFRESH to get a notification for
each sample. The first sample comes out with time_running = time_enabled =0,
subsequent samples return non-zero information. I suspect something is
wrong initially because of IOC_REFRESH. This is using an event group.

The program task_smpl.c is sampling another process. Although the scaling
information is requested, all samples come out with time_running =
time_enabled=0.
The rest of the sample is correct, so it's not like I am not correctly
reading the
sample. The program is using an event group.

I suspect both issues may be related.

You can obtain the test programs (which are open-source!), by cloning
the GIT tree
at:
         git://perfmon2.git.sourceforge.net/gitroot/perfmon2/libpfm4


Thanks.
