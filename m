Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYAVTOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYAVTOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYAVTOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:14:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYAVTOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:14:02 -0500
Subject: CONFIG_MARKERS
From: Jon Masters <jcm@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Tue, 22 Jan 2008 14:13:55 -0500
Message-Id: <1201029235.18144.62.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yo,

I notice in module.c:

#ifdef CONFIG_MARKERS
	if (!mod->taints)
		marker_update_probe_range(mod->markers,
			mod->markers + mod->num_markers, NULL, NULL);
#endif

Is this an attempt to not set a marker for proprietary modules? If so,
then this really should be the following conditional instead, because,
really we're not guaranteeing there won't be other taints (e.g. in RHEL
we already have the module signing patch, and then there's also the
TAINT_FORCED_MODULE, which arguably isn't a "taint" for markers):

#ifdef CONFIG_MARKERS
	if (!(mod->taints & TAINT_PROPRIETARY_MODULE))
		marker_update_probe_range(mod->markers,
			mod->markers + mod->num_markers, NULL, NULL);
#endif

Or am I missing something?

Jon.


