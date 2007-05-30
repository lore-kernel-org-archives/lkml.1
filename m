Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbXE3P4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbXE3P4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXE3P4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:56:44 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:13895 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbXE3P4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:56:43 -0400
X-IronPort-AV: i="4.14,594,1170662400"; 
   d="scan'208"; a="3250645:sNHT19608270"
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: linux-kernel@vger.kernel.org, openib-general@openib.org
Subject: Re: [ofa-general] Re: dealing with gcc 'comparison is always false' warnings
X-Message-Flag: Warning: May contain useful information
References: <20070530080518.GA29195@nostromo.devel.redhat.com>
	<adazm3mqqh3.fsf@cisco.com>
	<a781481a0705300841k2a02335eg66985129eaed28f4@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 30 May 2007 08:56:37 -0700
In-Reply-To: <a781481a0705300841k2a02335eg66985129eaed28f4@mail.gmail.com> (Satyam Sharma's message of "Wed, 30 May 2007 21:11:29 +0530")
Message-ID: <adaveeaqp8q.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 May 2007 15:56:38.0038 (UTC) FILETIME=[1B224B60:01C7A2D3]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > However, gcc is _just as correct_. It is only crying about seeing a condition
 > that the programmer could have written with some purpose in mind but which
 > is being completely compiled away by it when generating the code because
 > of it being a tautology / contradiction ...

Well, OK, but there's lots of things gcc could warn about.  How about

	while (1) { ...

By your argument gcc should warn that '1' always evaluates to true.
Or how about

#if 0

why shouldn't the preprocessor warn that the conditional is always false?

 > No, shutting gcc up wouldn't be the right thing, IMHO. These warnings are
 > a good reminder to the programmer to go and see if there is a real bug
 > somewhere and if something really needs to be done with the code (could
 > be simply to change the type of a variable to signed that was mistakenly
 > declared unsigned, f.e.).

OK, but suppose I looked at it and there's no bug.  Leaving the
warning has a cost too: it hides useful warnings (that might be
showing real bugs) in all the clutter.

 - R.
