Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab0BLQMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:12:46 -0500
Received: from smtp-out.google.com ([216.239.33.17]:22004 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab0BLQMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:12:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=cAqk0v8OpJ/bVxw3sVvrRxb/lMRjFeKLnLWXRuKOAXqGTTQ7HXteo95gtP1KRxR8w
	Q+6dJvrFywxTfm7WmdftA==
MIME-Version: 1.0
Date: Fri, 12 Feb 2010 17:12:38 +0100
Message-ID: <bd4cb8901002120812n7da16b6k29dd9b950ac68f25@mail.gmail.com>
Subject: Re: [PATCH 0/3 v2] new nmi_watchdog using perf events
From: Stephane Eranian <eranian@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don,

How is this new NMI watchdog code going to work when you also have OProfile
enabled in your kernel?

Today, perf_event disables the NMI watchdog while there is at least one event.
By releasing the PMU registers, it also allows for Oprofile to work.

But now with this new NMI watchdog code, perf_event never releases the PMU.
Thus, I suspect Oprofile will not work anymore, unless the NMI watchdog is
explicitly disabled. Up until now OProfile could co-exist with the NMI watchdog.
