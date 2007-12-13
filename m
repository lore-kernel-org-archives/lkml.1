Return-Path: <linux-kernel-owner+w=401wt.eu-S933495AbXLMVgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbXLMVgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933397AbXLMVgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:36:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54747 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933396AbXLMVgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:36:22 -0500
Date: Thu, 13 Dec 2007 22:35:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, ehabkost@redhat.com,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, zach@vmware.com,
       roland@redhat.com
Subject: Re: [PATCH] avoid ifdefs in desc.h, getting rid of pack_ldt and
	pack_tss
Message-ID: <20071213213517.GA25563@elte.hu>
References: <11975561713425-git-send-email-gcosta@redhat.com> <20071213202800.GD25130@elte.hu> <20071213205838.GA9649@elte.hu> <20071213212221.GA16747@elte.hu> <4761A385.1080301@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4761A385.1080301@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
>>
>>> could we _please_ use basic tools as vmlinux size comparison and 
>>> objcompare when unifying, to make sure it's a 100% identity conversion?
>>
>> case in point, the patch claims:
>>
>>>> No functional change is made.
>>
>> but vmlinux before/after size comparison shows:
>>
>>     text    data     bss     dec     hex filename
>>  8802894 1224910 3526656 13554460         ced31c vmlinux.before
>>  8803042 1224910 3526656 13554608         ced3b0 vmlinux.after
>
> Well, "no functional changes" is not quite the same thing as "no 
> object code changes".

yeah, true, but the safest way to ensure no functional changes is to get 
identical object code. In sched-devel.git i include obj comparisons to 
cleanup patches as a self-assurance (and later bughunt helper) to make 
sure a cleanup is really just a cleanup.

also, this patch, at first sight, should result in very similar (perhaps 
even the very same) object code. Not 1.2K larger.

	Ingo
