Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZDMGSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZDMGSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 02:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZDMGSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 02:18:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64746 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbZDMGSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 02:18:44 -0400
Message-ID: <49E2D8E3.4060708@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 14:17:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: mark get_parent_ip() notrace
References: <49D458B1.5000703@cn.fujitsu.com> <20090402122612.GB5965@nowhere>
In-Reply-To: <20090402122612.GB5965@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Apr 02, 2009 at 02:18:25PM +0800, Lai Jiangshan wrote:
>> Impact: remove redundancy tracing log
>>
>> When tracer is "function" or "function_graph", too much
>> "get_parent_ip" are recorded in ring_buffer.
> 
> 
> Thanks, indeed this get_parent_ip was a bit harrassing
> in the traces, though I still don't understand why it is
> called so often.
> 
> Anyway, tracing it seems to me not useful.
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> 

Hi, Ingo,
	Could you apply this fix?

get_parent_ip() is a helper function for ftace, and it is called
by preempt_disable() and preempt_enable(), so it is occurred very
often.

Lai.



