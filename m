Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbYC0JJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbYC0JJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYC0JJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:09:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52943 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbYC0JJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:09:42 -0400
Message-ID: <47EB63DC.3000702@cn.fujitsu.com>
Date: Thu, 27 Mar 2008 17:07:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       daniel@hozac.com, Pavel Emelyanov <xemul@openvz.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/1] cgroups: implement device whitelist (v6)
References: <20080326180543.GA27709@sergelap.austin.ibm.com> <20080327020403.5547e43f.akpm@linux-foundation.org>
In-Reply-To: <20080327020403.5547e43f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 26 Mar 2008 13:05:43 -0500 "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
>> (This is identical to the version I sent on Mar 19 in response to
>> the comments by Daniel Hokka Zakrisson, which are the last
>> comments I've gotten.)
>>
>> Implement a cgroup to track and enforce open and mknod restrictions on device
>> files.  A device cgroup associates a device access whitelist with each
>> cgroup.  A whitelist entry has 4 fields.  'type' is a (all), c (char), or
>> b (block).  'all' means it applies to all types and all major and minor
>> numbers.  Major and minor are either an integer or * for all.
>> Access is a composition of r (read), w (write), and m (mknod).
>>
>> The root device cgroup starts with rwm to 'all'.  A child devcg gets
>> a copy of the parent.  Admins can then remove devices from the
>> whitelist or add new entries.  A child cgroup can never receive a
>> device access which is denied its parent.  However when a device
>> access is removed from a parent it will not also be removed from the
>> child(ren).
>>
>> An entry is added using devices.allow, and removed using
>> devices.deny.  For instance
>>
>> 	echo 'c 1:3 mr' > /cgroups/1/devices.allow
>>
>> allows cgroup 1 to read and mknod the device usually known as
>> /dev/null.  Doing
>>
>> 	echo a > /cgroups/1/devices.deny
>>
>> will remove the default 'a *:* mrw' entry.
>>
>> CAP_SYS_ADMIN is needed to change permissions or move another task
>> to a new cgroup.  A cgroup may not be granted more permissions than
>> the cgroup's parent has.  Any task can move itself between cgroups.
>> This won't be sufficient, but we can decide the best way to
>> adequately restrict movement later.
> 
> The above should be in Documentation/cgroups.txt?
> 

You mean to add a Documentation/controller/devices.txt? ;)

