Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbYFPVaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbYFPVaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbYFPVaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:30:04 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:58563 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbYFPVaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:30:03 -0400
Message-ID: <4856DB4A.8020708@nortel.com>
Date: Mon, 16 Jun 2008 15:29:46 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Chris Friesen" <cfriesen@nortel.com>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       vatsa@linux.vnet.ibm.com, a.p.zijlstra@chello.nl
Subject: Re: odd timing bug with cgroups -- solved
References: <4852E8D5.3000503@nortel.com> <47364.1213416931@turing-police.cc.vt.edu> <48569895.7020701@nortel.com>
In-Reply-To: <48569895.7020701@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jun 2008 21:29:50.0100 (UTC) FILETIME=[1B8B1D40:01C8CFF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:

> I was thinking something like this as well, like maybe we can't move the 
> child to another group until it gets scheduled in once, or something 
> similar.

Well, it appears I was way off base.  My main task is SCHED_RR, and my 
child tasks put themselves into SCHED_OTHER.  I didn't have any realtime 
groups configured, so it was bailing out in the first conditional in 
cpu_cgroup_can_attach().

By also having the parent put the children into SCHED_OTHER, my testcase 
will handle both cases (parent or child runs first) and everything seems 
to be working fine.

Chris
