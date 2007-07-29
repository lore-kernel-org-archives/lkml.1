Return-Path: <linux-kernel-owner+w=401wt.eu-S965687AbXG2Xqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965687AbXG2Xqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 19:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965069AbXG2Xqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 19:46:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbXG2Xqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 19:46:30 -0400
Message-ID: <46AD26A3.4090606@redhat.com>
Date: Mon, 30 Jul 2007 07:45:39 +0800
From: Eugene Teo <eteo@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Martin Pitt <martin.pitt@ubuntu.com>
CC: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jeremy@goop.org, wwoods@redhat.com
Subject: Re: [PATCH 0/3] core_pattern: cleaned up repost/continuing post of
 core_pattern enhancements
References: <20070727200050.GA18946@hmsreliant.homelinux.net> <46AC6EAB.7000502@redhat.com> <20070729121444.GA9644@hmsreliant.homelinux.net> <46AC900E.9090405@redhat.com> <20070729155300.GC5794@piware.de>
In-Reply-To: <20070729155300.GC5794@piware.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Martin Pitt wrote:
> Eugene Teo [2007-07-29 21:03 +0800]:
>>>> Also, it is probably good to think how we can "drop privileges" while piping
>>>> the core dump output to an external program. A malicious user can potentially
>>>> use it as a possible backdoor since anything that is executed by "|program" will
>>>> be executed with root privileges.
>>>>
>>> It was my understanding that apport already did this.
>> I haven't looked at apport yet, but are you talking about the userspace portion of
>> apport or the kernel changes in the Ubuntu kernel?
> 
> Similarly to Neil's patches, the Ubuntu kernel calls the userspace
> helper as root, too. Apport drops privileges to the target process as
> soon as possible (there are a few things it needs to do before, like
> opening an fd to the crash file in /var/crash/ if that is only
> writeable by root).

Just sharing some thoughts. Wouldn't it be more logical to drop the privileges first,
then call the userspace helper program? I know that this will limit tools like apport
to be able to read and/or write files that are only writable by root, but there ought
to be a better way to do this? What if the program piped is not a legitimate program?

Also, maybe it is good to make this portion of the code optional too, so that if no
one is using this "ispipe" feature, we just turn it off.

Eugene
