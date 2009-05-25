Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbZEYQK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbZEYQK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 12:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZEYQKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 12:10:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:51704 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZEYQKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 12:10:12 -0400
Message-ID: <4A1AC234.9020307@kernel.org>
Date: Tue, 26 May 2009 01:07:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, chris@zankel.net,
       Jens Axboe <jens.axboe@oracle.com>, Dave Jones <davej@redhat.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 3/7] percpu: clean up percpu variable definitions
References: <1242805059-18338-1-git-send-email-tj@kernel.org> <1242805059-18338-4-git-send-email-tj@kernel.org> <200905251537.35981.rusty@rustcorp.com.au>
In-Reply-To: <200905251537.35981.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 16:07:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wed, 20 May 2009 05:07:35 pm Tejun Heo wrote:
>> Percpu variable definition is about to be updated such that
>>
>> * percpu symbols must be unique even the static ones
>>
>> * in-function static definition is not allowed
> 
> That spluttering noise is be choking on the title of this patch :)
> 
> Making these pseudo statics is in no way a cleanup.  How about we just
> say "they can't be static" and do something like:
> 
> /* Sorry, can't be static: that breaks archs which need these weak. */
> #define DEFINE_PER_CPU(type, var) \
> 	extern typeof(type) var; DEFINE_PER_CPU_SECTION(type, name, "")

Heh... well, even though I authored the patch, I kind of agree with
you.  Maybe it would be better to simply disallow static declaration /
definition at all.  I wanted to give a go at the original idea as it
seemed to have some potential.  The result isn't too disappointing but
I can't really say there are distinctively compelling advantages to
justify the added complexity and subtlety.

What do others think?  Is everyone happy with going extern only?

Thanks.

-- 
tejun
