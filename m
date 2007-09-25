Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbXIYOcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbXIYOcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbXIYOby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:31:54 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:59067 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbXIYObx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uUr12gsiDzseGaxJvLIfbZbHvd+ZYRTnj9UstDVia7kKXKxh5PZOyIhVAhDZBtrGSIxcgLKeQ8ledvQkuTO4yFJ916l034Ol3Oyt2mPUkHRINm5q5gKTsv1CIhniwXqQpyovEYUrXBLtvRS8uTr6cfUmR1sU1v7RsPccGXtY/ZU=
Message-ID: <46F91B72.1080109@gmail.com>
Date: Tue, 25 Sep 2007 23:30:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jonathan Corbet <corbet@lwn.net>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, greg@kroah.com, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
References: <Pine.LNX.4.44L0.0709251019510.3909-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0709251019510.3909-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
>> The unloading can proceed once module_unload_inhibit_cnt reaches zero.
>> An unloading thread only has to care about inhibition put in effect
>> before unloading has started, so there's no need to check again.
> 
> You haven't fully answered Jon's question.  Suppose
> module_unload_inhibit_cnt is nonzero, so the task adds itself to the
> module_unload_wait queue, changes to TASK_UNINTERRUPTIBLE, and calls
> schedule.  There's nothing to prevent somebody else from waking the
> task back up before the original inhibition has been lifted.

Hmmm... I might be missing something here.  Who else can wake up a
thread in uninterruptible sleep?

Thanks.

-- 
tejun
