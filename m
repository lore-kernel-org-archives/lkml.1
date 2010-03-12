Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab0CLViq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:38:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40957 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab0CLVio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:38:44 -0500
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=F6yTSysUtAdymFSz80AA:9 a=nkADddHv4oEPeDQmOYlHSQZCG5kA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <1268421627.4471.777.camel@gandalf.stny.rr.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>
	 <20100305171614.GC5244@nowhere>  <4B94A816.4090608@cn.fujitsu.com>
	 <1268061312.10871.1810.camel@gandalf.stny.rr.com>
	 <4B95AE4E.6060700@cn.fujitsu.com>
	 <1268101394.10871.1861.camel@gandalf.stny.rr.com>
	 <4B95C2AF.7010508@cn.fujitsu.com>
	 <1268421627.4471.777.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 12 Mar 2010 16:38:41 -0500
Message-ID: <1268429921.4471.780.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 14:20 -0500, Steven Rostedt wrote:
> On Tue, 2010-03-09 at 11:38 +0800, Li Zefan wrote:
> 
> > The segfault is from userspace. This is a segfault I just got:
> > 
> > ftrace_stack_ma[14989]: segfault at fe2e ip 00000000004474c0 sp 00007fffb97e38c0 error 4 in bash[400000+d1000]

I found a reproducer that triggers in seconds:

# echo 1 > options/userstacktrace
# echo 1 > events/lock/enable
# while do :; ls > /dev/null; done

Seems the triggering of the userspace stack trace may be messing with
dynamic linking. Note, this does not happen on all of my boxes. It
happens on fedora 11 but not on RHEL 5.1.

I'm still investigating.

-- Steve


