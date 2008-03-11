Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYCKSSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYCKSSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYCKSR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:17:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbYCKSR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:17:57 -0400
Message-ID: <47D6CCAA.7020506@redhat.com>
Date: Tue, 11 Mar 2008 14:17:14 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ia64 <linux-ia64@vger.kernel.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [PATCH -mm] kprobes: kprobe-booster for ia64
References: <47D166E7.2050803@redhat.com>	 <1205120600.20271.3.camel@sli10-desk.sh.intel.com>	 <47D57D28.7070100@redhat.com> <1205198417.24178.10.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1205198417.24178.10.camel@sli10-desk.sh.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaohua,

Shaohua Li wrote:
> Hi,
> On Tue, 2008-03-11 at 02:25 +0800, Masami Hiramatsu wrote:
>> Shaohua Li wrote:
>>> On Sat, 2008-03-08 at 00:01 +0800, Masami Hiramatsu wrote:
>>> There is no lock to protect the flag. If one cpu invokes other_kp
>> and
>>> the other cpu is changing the flag, what's the result?
>> I think that other cpu never change the flag, because the caller of
>> this
>> function(__register_kprobe) locks kprobe_mutex in kernel/kprobes.c.
> I mean if one cpu is doing register_kprobe, which will change other_kp's
> flag. Another cpu is running into other_kp's break point, which will
> look at the flag, there is a window (between the second cpu looks at the
> flag and doing boost) the first cpu can change the flag in the window.
> It appears we will lose one probe, but not sure if this is over
> thinking.

Sure, it is possible to lose just one probe in that time, but in next time,
we do not lose it. So, I think it is not a problem.

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


