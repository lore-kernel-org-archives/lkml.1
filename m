Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZKHXjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZKHXjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 18:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZKHXjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 18:39:22 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50953 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZKHXjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 18:39:21 -0500
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] Removal of binary sysctl support
References: <m13a4pjjh9.fsf@fess.ebiederm.org>
	<200911082215.HGJ57827.SJOVFFOHMOLFQt@I-love.SAKURA.ne.jp>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 08 Nov 2009 15:39:21 -0800
In-Reply-To: <200911082215.HGJ57827.SJOVFFOHMOLFQt@I-love.SAKURA.ne.jp> (Tetsuo Handa's message of "Sun\, 8 Nov 2009 22\:15\:46 +0900")
Message-ID: <m1bpjch9hy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> Hello.
>
> Eric W. Biederman wrote:
>> 
>> This patchset reimplements sys_sysctl as a compatibility wrapper
>> around /proc/sys.  After which it removes all of the code to all over
>> the kernel that is used today to implement the binary sysctls.
>> 
>> I am posting this patchset to give everyone a heads up what is in
>> flight.
>> 
>> I intend to carry all of these patches in my sysctl tree.
>> 
>> If you add new sysctls to other trees please don't set the .ctl_name
>> or .strategy fields in struct ctl_table, as setting those fields
>> is unnecessary now and are removed by this patchset.
>
> I have two questions.
>
> Is there (or was there) an entry with ->procname == NULL ? (I thought so
> because the loop condition is
>
> 	for ( ; table->ctl_name || table->procname; table++) {
>
> .)
>
> This patchset removes ->ctl_name on the assumption that ->procname != NULL ?

There has been a gradual transition from the assumption that the table ends with
!ctl_name to the assumption that procname == NULL.  There is no sysctl entry
with a valid ctl_name without a valid procname.

Eric
