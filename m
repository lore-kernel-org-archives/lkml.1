Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZAIGaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZAIGaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZAIGaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:30:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51872 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbZAIGaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:30:46 -0500
Message-ID: <4966EEDD.5070204@cn.fujitsu.com>
Date: Fri, 09 Jan 2009 14:29:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com> <6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
In-Reply-To: <6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, Jan 8, 2009 at 9:32 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Motivation: Simply classify Applications by cgroup
>>  When using cgroup for classifying applications, some kind of "control" or
>>  "account" subsys must be used. For flexible use of cgroup's nature of
>>  classifying applications, NOOP is useful. It can be used regardless of
>>  resource accounting unit or name spaces or some controls.
>>  IOW, NOOP cgroup allows users to tie PIDs with some nickname.
> 
> I agree that the idea is useful. But to me it seems to a bit
> artificial that you still have to mount some kind of subsystem purely
> to get the grouping, and that you can only have one such grouping.
> 
> I think I'd prefer the ability to mount a cgroups hierarchy without
> *any* subsystems (maybe with "-o none"?) which would give you a
> similar effect, but without you needing to know about a special no-op
> subsystem, and would allow you to have multiple "no-op" groupings.
> 

Agreed, but it can't work by just removing the checking in cgroup mount option,
I just tried it:

static int parse_cgroupfs_options(char *data,
				     struct cgroup_sb_opts *opts)
{
	...
-	if (!opts->subsys_bits)
-		return -EINVAL;
	...
}

