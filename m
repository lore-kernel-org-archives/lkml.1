Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab0BOQIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:08:38 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:44894 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab0BOQIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:08:37 -0500
Message-ID: <4B797005.6030308@nortel.com>
Date: Mon, 15 Feb 2010 10:02:13 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: tracking memory usage/leak in "inactive" field in /proc/meminfo?
References: <4B71927D.6030607@nortel.com> <20100210093140.12D9.A69D9226@jp.fujitsu.com> <4B72E74C.9040001@nortel.com> <20100213062905.GF11364@balbir.in.ibm.com>
In-Reply-To: <20100213062905.GF11364@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Feb 2010 16:08:31.0890 (UTC) FILETIME=[1E677720:01CAAE59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 12:29 AM, Balbir Singh wrote:

> OK, I did not find the OOM kill output, dmesg. Is the OOM killer doing
> the right thing? If it kills the process we suspect is leaking memory,
> then it is working correctly :) If the leak is in kernel space, we
> need to examine the changes more closely.

I didn't include the oom killer message because it didn't seem important
in this case.  The oom killer took out the process with by far the
largest memory consumption, but as far as I know that process was not
the source of the leak.

It appears that the leak is in kernel space, given the unexplained pages
that are part of the active/inactive list but not in
buffers/cache/anon/swapcached.

> kernel modifications that we are unaware of make the problem harder to
> debug, since we have no way of knowing if they are the source of the
> problem.

Yes, I realize this.  I'm not expecting miracles, just hoping for some
guidance.


>> Committed_AS	12666508	12745200	7700484
> 
> Comitted_AS shows a large change, does the process that gets killed
> use a lot of virtual memory (total_vm)? Please see my first question
> as well. Can you try to set
> 
> vm.overcommit_memory=2
> 
> and run the tests to see if you still get OOM killed.

As mentioned above, the process that was killed did indeed consume a lot
of memory.  I could try running with strict memory accounting, but would
you agree that that given the gradual but constant increase in the
unexplained pages described above, currently that looks like a more
likely culprit?

Chris
