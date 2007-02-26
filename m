Return-Path: <linux-kernel-owner+w=401wt.eu-S1751390AbXBZXYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbXBZXYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbXBZXYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:24:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbXBZXYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:24:07 -0500
Message-ID: <45E36844.5040402@redhat.com>
Date: Mon, 26 Feb 2007 18:07:48 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: netconsole module cannot be removed
References: <45E3447F.9080706@redhat.com> <20070226133156.3bfd2a74@freekitty>
In-Reply-To: <20070226133156.3bfd2a74@freekitty>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Mon, 26 Feb 2007 15:35:11 -0500
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
>> Trying to remove netconsole, rmmod goes into a tight loop with
>> 100% CPU usage. It can't be killed with 'kill -9'. Shutdown
>> works, though. Kernel is 2.6.20 FC6 config, and I'm 99.9%
>> sure the module signing has nothing to do with this.
>>
> 
> No it probably has to do with printing a message during module removal.
> 

Works fine in 2.6.19.5

Hangs in vanilla 2.6.20 in netpoll_cleanup()

Call trace: 
 flush_cpu_workqueue
 flush_workqueue
 cancel_rearming_delayed_workqueue
 netpoll_cleanup
 sys_delete_module

It varies, but is always in one of the first three functions when you
do alt-sysrq-p.

