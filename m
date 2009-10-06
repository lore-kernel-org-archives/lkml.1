Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbZJFOnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbZJFOnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932836AbZJFOnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:43:21 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:4473 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813AbZJFOnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kPeoFhGuNPt6l4sNmJ++H6nhCC4WEkG628bTdMnHPDPw6TaiqORf82tDx/0Wn2tqpd
         0f0nkOcjBmPh5paL3fxYmMiuUGefY2oKl7COIjS8HEw7XZLbHRxjjVM5P+L7SAdXlNUb
         qemFE2IdToYH5mfHW4ERN0BW4RRkuVititXPE=
From: Stephane Eranian <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, paulus@samba.org, a.p.zijlstra@chello.nl,
       perfmon2-devel@lists.sf.net, Stephane Eranian <eranian@gmail.com>
Subject: [PATCH 0/2] perf_events: correct event assignments on Intel processors
Date: Tue,  6 Oct 2009 16:42:07 +0200
Message-Id: <1254840129-6198-1-git-send-email-eranian@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This series of patches corrects the assignment of events to counters
	for the Intel X86 processors.

	Not all events can be measured on any counter. Not all filters can
	be used on fixed counters.

	The current implementation silently returns bogus counts in case the
	event is programmed into the wrong counter.

	Signed-off-by: Stephane Eranian <eranian@gmail.com>
---
 arch/x86/include/asm/perf_event.h |   11 ++++
 arch/x86/kernel/cpu/perf_event.c  |  112 +++++++++++++++++++++++++++++++++++-
 2 files changed, 119 insertions(+), 4 deletions(-)

