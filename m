Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbZJ0Sa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbZJ0Sa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZJ0SaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:30:25 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:46315 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbZJ0SaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:30:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:x-age:x-location
         :x-os:x-face:content-type:content-transfer-encoding;
        b=JJvFwR17fQpGnS0YNpAVD1Q8JvBS48jTXZvn7HEZANNFig4zgNUCaG3T0/mPJErcH+
         Pu8yPcqNHiiqmdk8hR+qEZoSmsrq3okTv6uWHGpvcZuzBAFeW3E3N2mKCSy7zXirg6OC
         3SiU5bUCoe7iCzos3K+3W4CH8YQTP1gnH7GFM=
Message-ID: <4AE73C40.8070307@gmail.com>
Date: Tue, 27 Oct 2009 19:30:24 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, hugh.dickins@tiscali.co.uk,
       akpm@linux-foundation.org, rientjes@google.com
Subject: Re: Memory overcommit
References: <hav57c$rso$1@ger.gmane.org>	 <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com>	 <hb2cfu$r08$2@ger.gmane.org>	 <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com>	 <4ADE3121.6090407@gmail.com>	 <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>	 <4AE5CB4E.4090504@gmail.com>	 <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>	 <4AE72A0D.9070804@gmail.com> <2f11576a0910271102g60dcdd1dj8f3df213bc64a51d@mail.gmail.com>
In-Reply-To: <2f11576a0910271102g60dcdd1dj8f3df213bc64a51d@mail.gmail.com>
X-Age: 25
X-Location: Lovran, Croatia
X-OS: Debian GNU/Linux
X-Face: +Lg7^E:?#]P.Y{N@61yW{aY#>fRcOE6MMqgAM|Kwk"fK!y!i4+h6&?E`Jt@uame[-SLu#*<fGtMmVfh8qo,"kJ'ql^Ni?]l|ax{fvvmD<k:2w^e(y8J2YWO`M=u17OWli}Rf^e:|w2]LulgE(:u0|}mNBZFid[YEWAC>?k:)dZv<!'a)N0b=LFDZKY!!@[%mmVO-7y`Nkj?{<C6rm9Uz$EXu;0I<PubM.Po|vlT.2&vPkJG07G.l0Ty)B/dR0k:KU<;?+WAR\f_ms2b~i"g@e}a)i1N$WLBa{vBoDs4!}k\g?lItt=|]=M{Fm@ce|^6PXq&
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

>>> I attached a scirpt for checking oom_score of all exisiting process.
>>> (oom_score is a value used for selecting "bad" processs.")
>>> please run if you have time.
>> 96890   21463   VirtualBox // OK
>> 118615  11144   kded4 // WRONG
>> 127455  11158   knotify4 // WRONG
>> 132198  1       init // WRONG
>> 133940  11151   ksmserver // WRONG
>> 134109  11224   audacious2 // Audio player, maybe
>> 145476  21503   VirtualBox // OK
>> 174939  11322   icedove-bin // thunderbird, maybe
>> 178015  11223   akregator // rss reader, maybe
>> 201043  22672   krusader  // WRONG
>> 212609  11187   krunner // WRONG
>> 256911  24252   test // culprit, malloced 1GB
>> 1750371 11318   run-mozilla.sh // tiny, parent of firefox threads
>> 2044902 11141   kdeinit4 // tiny, parent of most KDE apps
> 
> Verdran, I made alternative improvement idea. Can you please mesure
> badness score
> on your system?
> Maybe your culprit process take biggest badness value.

Thanks, I'll test it during the week. But note that not every user
reboots its computer everyday. I, for example, usually have it up for
days. And when it comes to my laptop - weeks, as I just suspend it when
I don't use it. Maybe the best way is to combine two patches. Also, you
and others could also test these patches. It is not only my kernel that
behaves strange. :)

> Note: this patch change time related thing. So, please drink a cup of
> coffee before mesurement.
> small rest time makes correct test result.

OK. :)

Regards,

Vedran

