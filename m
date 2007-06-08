Return-Path: <linux-kernel-owner+w=401wt.eu-S970047AbXFHRAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970047AbXFHRAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759732AbXFHRAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:00:21 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:13861 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713AbXFHRAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:00:19 -0400
Message-ID: <46698B1D.3000806@de.ibm.com>
Date: Fri, 08 Jun 2007 19:00:13 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, jbaron@redhat.com, rostedt@goodmis.org,
       billh@gnuppy.monkey.org, mingo@elte.hu, linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
References: <1181165656.7133.23.camel@dix> <1181202258.7348.217.camel@twins>
In-Reply-To: <1181202258.7348.217.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> I'm confused as to where the class->stat objects are initialised? Is
> that done in lock_stat_init()? If so, then you have a bug.

static struct lock_class lock_classes[MAX_LOCKDEP_KEYS];

I assume this gets us class structures containing all zeros, doesn't it?
Then class->stat is zeros as well, which is handled by lib/statistics.
(In this case, data gathering hasn't been turned on yet, and statistic_inc()
and similar functions don't access other areas of struct statistic.)

Martin

