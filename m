Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbZACQJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbZACQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 11:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758933AbZACQJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 11:09:51 -0500
Received: from relay1.sgi.com ([192.48.179.29]:51251 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758919AbZACQJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 11:09:50 -0500
Message-ID: <495F8DCA.1060905@sgi.com>
Date: Sat, 03 Jan 2009 08:09:46 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask tree
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <200901031751.00076.rusty@rustcorp.com.au> <20090103105208.GA19080@elte.hu> <495F7D27.8020104@sgi.com> <20090103150634.GA28693@elte.hu> <495F84D8.1070404@sgi.com> <20090103154733.GA8111@elte.hu> <20090103160017.GA8920@elte.hu>
In-Reply-To: <20090103160017.GA8920@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> i suspect it's:
>>
>> | commit 2d22bd5e74519854458ad372a89006e65f45e628
>> | Author: Mike Travis <travis@sgi.com>
>> | Date:   Wed Dec 31 18:08:46 2008 -0800
>> |
>> |     x86: cleanup remaining cpumask_t code in microcode_core.c
>>
>> as the microcode is loaded during CPU onlining.
> 
> yep, that's the bad one. Should i revert it or do you have a safe fix in 
> mind?
> 
> 	Ingo

Probably revert for now.  There are a few more following patches that also
use 'work_on_cpu' so a better (more global?) fix should be used.

Any thought on using a recursive lock for cpu-hotplug-lock?  (At least for
get_online_cpus()?)

Thanks,
Mike
