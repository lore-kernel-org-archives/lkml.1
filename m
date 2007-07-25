Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbXGYPqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbXGYPqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbXGYPqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:46:32 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:50196 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbXGYPqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:46:32 -0400
Message-ID: <46A77054.8040203@free.fr>
Date: Wed, 25 Jul 2007 17:46:28 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
CC: Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Pin-pointing the root of unusual application latencies
References: <469600F7.3060603@free.fr> <20070725133835.GA17616@elte.hu> <46A758B5.9070602@free.fr> <200707251728.00207.fzu@wemgehoertderstaat.de>
In-Reply-To: <200707251728.00207.fzu@wemgehoertderstaat.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Wiese wrote:

> John Sigler wrote:
> 
>> Is there some form of priority inheritance? Does the IRQ handler get a 
>> priority boost if a high priority task is waiting for it?
> 
> No. But that would be "nice to have".

No to the first question? to the second question? or to both? :-)

In kernel/futex.c does "PI" stand for Priority Inheritance?

e.g.

/*
  * Priority Inheritance state:
  */
struct futex_pi_state {
	/*
	 * list of 'owned' pi_state instances - these have to be
	 * cleaned up in do_exit() if the task exits prematurely:
	 */
	struct list_head list;

	/*
	 * The PI object:
	 */
	struct rt_mutex pi_mutex;

	struct task_struct *owner;
	atomic_t refcount;

	union futex_key key;
};
