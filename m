Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbYKDO3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbYKDO3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYKDO3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:29:17 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52433 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbYKDO3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:29:16 -0500
Date: Tue, 4 Nov 2008 19:58:24 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, mhiramat@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kprobes: disable preempt for module_text_address()
Message-ID: <20081104142824.GA24326@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <490FE405.1000105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490FE405.1000105@cn.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 01:56:21PM +0800, Lai Jiangshan wrote:
> 
> __register_kprobe() may be preempted after module_text_address()
> but before try_module_get(), and in this interval the module may be
> unloaded and try_module_get(probed_mod) will access to invalid address.
> this patch uses preempt_disable() to protect it.

Looking at other users of try_module_get, I don't see this as a usage
model being followed elsewhere. Also, in case such a preemption does
happen, module_is_live() will fail and we should still be ok.

I don't see a reason for this patch unless there is a clear failure case
(register_kprobe failing 'cos of a module unload is perfectly ok).

Ananth
