Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbZKDQZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbZKDQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZKDQZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:25:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbZKDQZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:25:25 -0500
Message-ID: <4AF1AACE.6060705@redhat.com>
Date: Wed, 04 Nov 2009 17:24:46 +0100
From: Jan Safranek <jsafrane@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, balbir@linux.vnet.ibm.com,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
References: <20091104063005.GC3560@balbir.in.ibm.com> <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com> <20091104081618.GD3560@balbir.in.ibm.com> <1257348117.31972.4360.camel@nimitz> <20091104161142.GA8825@us.ibm.com>
In-Reply-To: <20091104161142.GA8825@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2009 05:11 PM, Serge E. Hallyn wrote:
> Quoting Dave Hansen (dave@linux.vnet.ibm.com):
>> On Wed, 2009-11-04 at 13:46 +0530, Balbir Singh wrote:
>>> The reason I liked /dev/cgroup was because cpusets could be
>>> mounted at /dev/cpuset or /dev/cgroup/cpuset. My concern with /cgroup
>>> is that a ls "/" now becomes larger in size. But I'll take your vote
>>> for it as +1 for /cgroup.
>>
>> /dev/pts is a decent precedent for doing it under /dev, although it does
>> deal with actual devices.  cgroups do not.
>
> Hmm, on whose behalf are you making this decision?
>
> LSB people will want to avoid using /cgroup,

LSB (and FHS) IMHO does not specify any place for such stuff:

/dev - for devices only, cgroups are not devices
/mnt - for admin temporary mounts and "should not affect the manner in 
which any program is run"
/var - for "any unsorted variable data", cgroups are not "unsorted 
variable data", it's interface to kernel

FHS does not specify either /sys and /selinux and it seems to me nobody 
complains about them.

/sys/cgroup would be the best, if sysfs supported mkdir(). But it does 
not :(. Our kernel guys told me it's relatively easy to create new empty 
directory /sys/cgroup (or /sys/kernel/cgroup), but it must be compiled 
into kernel or a module. Then I could mount some tmpfs to it, create 
/sys/cgroup/cpu, /sys/cgroup/memory etc. and mount the control group 
hierarchies there... but as you can see, it's really really ugly thing 
to do.

Jan
