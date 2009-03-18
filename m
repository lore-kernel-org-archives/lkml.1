Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbZCRCvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbZCRCvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 22:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbZCRCva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 22:51:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57169 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbZCRCv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 22:51:29 -0400
Message-ID: <49C06159.9010704@cn.fujitsu.com>
Date: Wed, 18 Mar 2009 10:50:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/ftrace] ftrace: remove struct list_head from	struct
 dyn_ftrace
References: <49BA2C9F.8020009@cn.fujitsu.com> <tip-e94142a67f8bad494c593f0a07c9fc2fbec98c0e@git.kernel.org> <20090316123607.GA5096@nowhere> <20090316124229.GB5096@nowhere>
In-Reply-To: <20090316124229.GB5096@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> 
> 
> May be I'm wrong. May be I misunderstood this patch.
> But I don't understand how flags can be used at the same time as a pointer
> and as a flag value.
> 

When a new dyn_ftrace is added to ftrace_new_addrs list, the flag is 0,
it's always 0 until this dyn_ftrace is removed from the list, so we can
reuse the flag field. As Steven's suggest, using an union is better.

ftrace_convert_nops()
  ftrace_record_ip() // allocate dyn_ftrace, and add it
                     // to ftrace_new_addrs list
  ftrace_update_code() // remove it from ftrace_new_addrs.

Lai.

