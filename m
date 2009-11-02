Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbZKBTgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbZKBTgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbZKBTgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:36:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725AbZKBTgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:36:35 -0500
Date: Mon, 2 Nov 2009 20:34:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
Message-ID: <20091102193445.GA9948@elte.hu>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com> <87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com> <20091026215544.GA3355@basil.fritz.box> <4AEB3D95.50300@sgi.com> <4AEEBE65.3070202@linux.intel.com> <4AEF3143.2030701@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEF3143.2030701@sgi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

>
>
> Andi Kleen wrote:
>> Mike Travis wrote:
>>>
>>> This set of patches limits the number of repetitious messages which  
>>> contain
>>> no additional information.  Much of this information is obtainable  
>>> from the
>>> /proc and /sysfs.   Most of the messages are also sent to the kernel log
>>> buffer as KERN_DEBUG messages so it can be used to examine more  
>>> closely any
>>> details specific to a processor.
>>
>> What would be good is to put the information from the booting CPUs
>> into some buffer and print it visibly if there's a timeout detected on  
>> the BP.
>
> What do you think of this idea....  Add a "mark kernel log buffer" 
> function, and then if any KERN_NOTE or above happens, it sends the 
> marked info from the kernel log buffer to the console before the 
> current message.  Set the marker to '0' to clear.

That's _way_ too complex really, for little benefit. (If there's a boot 
hang people will re-try anyway (and this time with a serial console 
attached or so), and they can add various boot options to increase 
verbosity - depending in which phase the bootup hung.)

So please go with the simple solution i suggested days ago: print stuff 
on the boot CPU but after that only a single line per AP CPU.

	Ingo
