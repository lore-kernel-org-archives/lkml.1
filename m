Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbZFYOBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbZFYOBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZFYOB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:01:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbZFYOBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:01:25 -0400
From: Thomas Renninger <trenn@suse.de>
To: kernel@stable.org
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rjw@sisk.pl, hidave.darkstar@gmail.com, penberg@cs.helsinki.fi,
       kernel-testers@vger.kernel.org, davej@redhat.com,
       mathieu.desnoyers@polymtl.ca
Subject: Fix dead lock in cpufreq for CPU hotplug and suspend for 2.6.30.stable
Date: Thu, 25 Jun 2009 16:01:23 +0200
Message-Id: <1245938485-12663-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20090623193215.GA31374@elte.hu>
References: <20090623193215.GA31374@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is about the dead locks happening since cancel_delayed_work_sync()
got added to the ondemand/conservative governors.

I truncated a bit the CC list to most important people and mailing lists.

The patch is intended for 2.6.30 stable, but both patches together did
not get tested yet. If someone could verify this working now that
would be great.

I first wanted to provide something for .31 and then backport, but
it wouldn't patch clean anymore anyway and I don't want to wait
any longer.

Rafael: These should solve the regression bug:
http://bugzilla.kernel.org/show_bug.cgi?id=13475


