Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbZJ2LLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbZJ2LLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 07:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZJ2LLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 07:11:30 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39266 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbZJ2LL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 07:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:x-age:x-location
         :x-os:x-face:content-type:content-transfer-encoding;
        b=qLELXoFGXEKAZlqvMU1nGmRuBR0dXrCNCGfgITwBw9gJJ+zLiJf7kP/v5gxE9AWGjI
         K3tCZ9SA9CJgWkLPz89a5sG3WZq6vFV6VJwFELNr+GENj4mLkclFEE0Gw9MVvJwMO4LL
         6YWGmOkgefwfkTJ6e2WskMnqZoh6fFcWRSL+0=
Message-ID: <4AE97861.1070902@gmail.com>
Date: Thu, 29 Oct 2009 12:11:29 +0100
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
References: <hav57c$rso$1@ger.gmane.org> <hb2cfu$r08$2@ger.gmane.org> <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com> <4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com> <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com> <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com> <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <20091028135519.805c4789.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910272205200.7507@chino.kir.corp.google.com> <20091028150536.674abe68.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910272311001.15462@chino.kir.corp.google.com> <20091028152015.3d383cd6.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910290136000.11476@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0910290136000.11476@chino.kir.corp.google.com>
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

> Right, because in Vedran's latest oom log it shows that Xorg is preferred 
> more than any other thread other than the memory hogging test program with 
> your patch than without.  I pointed out a clear distinction in the killing 
> order using both total_vm and rss in that log and in my opinion killing 
> Xorg as opposed to krunner would be undesireable.

But then you should rename OOM killer to TRIPK:
Totally Random Innocent Process Killer

If you have OOM situation and Xorg is the first, that means it's leaking
memory badly and the system is probably already frozen/FUBAR. Killing
krunner in that situation wouldn't do any good. From a user perspective,
nothing changes, system is still FUBAR and (s)he would probably reboot
cursing linux in the process.

