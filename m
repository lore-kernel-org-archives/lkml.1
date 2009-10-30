Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbZJ3N7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbZJ3N7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 09:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbZJ3N7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 09:59:35 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:38087 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbZJ3N7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 09:59:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:x-age:x-location
         :x-os:x-face:content-type:content-transfer-encoding;
        b=rt70mLOKINYzgIv6pFr3pFj2wh42ZhqDG52jvyOHi//XOIuv3ohwHR5MmmDsJTpACc
         0D8zVX4iws+cxRJZ7Bwlyz8EZr+oMAc7Cm8LENgvTHnBeAuggBwbEe63IJkozeacW0Lv
         yR0u4ivR/wZ6gXRV0ODd4VMvNxFx5Er6NmHGI=
Message-ID: <4AEAF145.3010801@gmail.com>
Date: Fri, 30 Oct 2009 14:59:33 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
References: <hav57c$rso$1@ger.gmane.org> <4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com> <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com> <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com> <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <20091028135519.805c4789.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910272205200.7507@chino.kir.corp.google.com> <20091028150536.674abe68.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910272311001.15462@chino.kir.corp.google.com> <20091028152015.3d383cd6.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910290136000.11476@chino.kir.corp.google.com> <4AE97861.1070902@gmail.com> <alpine.DEB.2.00.0910291248480.2276@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0910291248480.2276@chino.kir.corp.google.com>
X-Age: 25
X-Location: Lovran, Croatia
X-OS: Debian GNU/Linux
X-Face: +Lg7^E:?#]P.Y{N@61yW{aY#>fRcOE6MMqgAM|Kwk"fK!y!i4+h6&?E`Jt@uame[-SLu#*<fGtMmVfh8qo,"kJ'ql^Ni?]l|ax{fvvmD<k:2w^e(y8J2YWO`M=u17OWli}Rf^e:|w2]LulgE(:u0|}mNBZFid[YEWAC>?k:)dZv<!'a)N0b=LFDZKY!!@[%mmVO-7y`Nkj?{<C6rm9Uz$EXu;0I<PubM.Po|vlT.2&vPkJG07G.l0Ty)B/dR0k:KU<;?+WAR\f_ms2b~i"g@e}a)i1N$WLBa{vBoDs4!}k\g?lItt=|]=M{Fm@ce|^6PXq&
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:

> On Thu, 29 Oct 2009, Vedran Furac wrote:
> 
>> But then you should rename OOM killer to TRIPK:
>> Totally Random Innocent Process Killer
>>
> 
> The randomness here is the order of the child list when the oom killer 
> selects a task, based on the badness score, and then tries to kill a child 
> with a different mm before the parent.
> 
> The problem you identified in http://pastebin.com/f3f9674a0, however, is a 
> forkbomb issue where the badness score should never have been so high for 
> kdeinit4 compared to "test".  That's directly proportional to adding the 
> scores of all disjoint child total_vm values into the badness score for 
> the parent and then killing the children instead.

Could you explain me why ntpd invoked oom killer? Its parent is init. Or
syslog-ng?

> That's the problem, not using total_vm as a baseline.  Replacing that with 
> rss is not going to solve the issue and reducing the user's ability to 
> specify a rough oom priority from userspace is simply not an option.

OK then, if you have a solution, I would be glad to test your patch. I
won't care much if you don't change total_vm as a baseline. Just make
random killing history.

Regards,

Vedran

