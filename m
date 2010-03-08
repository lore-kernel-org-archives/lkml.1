Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0CHXTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:19:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:36931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0CHXTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:19:17 -0500
Message-ID: <4B958673.3000105@kernel.org>
Date: Tue, 09 Mar 2010 08:21:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, oleg@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 2/4] stop_machine: reimplement using cpuhog
References: <1268063603-7425-1-git-send-email-tj@kernel.org>	<1268063603-7425-3-git-send-email-tj@kernel.org> <20100308083204.1300b97a@infradead.org>
In-Reply-To: <20100308083204.1300b97a@infradead.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 08 Mar 2010 23:18:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/09/2010 01:32 AM, Arjan van de Ven wrote:
> On Tue,  9 Mar 2010 00:53:21 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
>> Reimplement stop_machine using cpuhog.  As cpuhogs are guaranteed to
>> be available for all online cpus, stop_machine_create/destroy() are no
>> longer necessary and removed.
> 
> question;
> stop_machine pretty much also stops interrupts (it has to, at least for
> the users of stop_machine).. do cpu_hogs do this too?
> 
> (if they don't, cpu_hogs aren't safe for some of the users of
> stop_machine, like code patching etc)

That is and has always been done by stop_machine cpuhog callback
stop_cpu().  Only the thread pool is changed.  The logic stays the
same.

Thanks.

-- 
tejun
