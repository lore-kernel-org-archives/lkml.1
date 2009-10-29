Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZJ2LBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZJ2LBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 07:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZJ2LBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 07:01:47 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63065 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbZJ2LBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 07:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:x-age:x-location
         :x-os:x-face:content-type:content-transfer-encoding;
        b=OHIs9t+aRtG5t6/d8NvQ4NsQ3B6TsMDsDjjk9/KTL6JTAF2Ldue6tSDerfe92NC4n2
         Ap6w/8GegLNyXygsMMFTqe6QCgAuAJ3p6mP4bDOK6TaQpNsAke1k6+0ZKGtcRBsHLYtd
         wo5xA071lgYuU28VzJcH+JpmDR7wcvXzCfsd8=
Message-ID: <4AE97618.6060607@gmail.com>
Date: Thu, 29 Oct 2009 12:01:44 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
References: <hav57c$rso$1@ger.gmane.org> <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com> <hb2cfu$r08$2@ger.gmane.org> <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com> <4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com> <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com> <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com> <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <4AE846E8.1070303@gmail.com> <alpine.DEB.2.00.0910281307370.23279@chino.kir.corp.google.com> <4AE9068B.7030504@gmail.com> <alpine.DEB.2.00.0910290132320.11476@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0910290132320.11476@chino.kir.corp.google.com>
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
>>> We would know if you posted the data.
>> I need to find some free time to destroy a session on a computer which I
>> use for work. You could easily test it yourself also as this doesn't
>> happen only to me.
>>
>> Anyways, here it is... this time it started with ntpd:
>>
>> http://pastebin.com/f3f9674a0
>>
> 
> That oom log shows 12 ooms but no tasks actually appear to be getting 
> killed (there're no "Killed process 1234 (task)" found).  Do you have any 
> idea why?

That's /var/log/messages. I posted it and not dmesg because whole log
didn't fit dmesg buffer, here is waht i have (compare timestamps):

% dmesg|grep -i kill

[ 1493.064458] Out of memory: kill process 6304 (kdeinit4) score 1190231
or a child
[ 1493.064467] Killed process 6409 (konqueror)
[ 1493.261149] knotify4 invoked oom-killer: gfp_mask=0x201da, order=0,
oomkilladj=0
[ 1493.261166]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
[ 1493.276528] Out of memory: kill process 6304 (kdeinit4) score 1161265
or a child
[ 1493.276538] Killed process 6411 (krusader)
[ 1499.221160] akregator invoked oom-killer: gfp_mask=0x201da, order=0,
oomkilladj=0
[ 1499.221178]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
[ 1499.236431] Out of memory: kill process 6304 (kdeinit4) score 1067593
or a child
[ 1499.236441] Killed process 6412 (irexec)
[ 1499.370192] firefox-bin invoked oom-killer: gfp_mask=0x201da,
order=0, oomkilladj=0
[ 1499.370209]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
[ 1499.385417] Out of memory: kill process 6304 (kdeinit4) score 1066861
or a child
[ 1499.385427] Killed process 6420 (xchm)
[ 1499.458304] kio_file invoked oom-killer: gfp_mask=0x201da, order=0,
oomkilladj=0
[ 1499.458333]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
[ 1499.458367]  [<ffffffff81120900>] ? d_kill+0x5c/0x7c
[ 1499.473573] Out of memory: kill process 6304 (kdeinit4) score 1043690
or a child
[ 1499.473582] Killed process 6425 (kio_file)
[ 1500.250746] korgac invoked oom-killer: gfp_mask=0x201da, order=0,
oomkilladj=0
[ 1500.250765]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
[ 1500.266186] Out of memory: kill process 6304 (kdeinit4) score 1020350
or a child
[ 1500.266196] Killed process 6464 (icedove)
[ 1500.349355] syslog-ng invoked oom-killer: gfp_mask=0x201da, order=0,
oomkilladj=0
[ 1500.349371]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
[ 1500.364689] Out of memory: kill process 6304 (kdeinit4) score 1019864
or a child
[ 1500.364699] Killed process 6477 (kio_http)
[ 1500.452151] kded4 invoked oom-killer: gfp_mask=0x201da, order=0,
oomkilladj=0
[ 1500.452167]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
[ 1500.452196]  [<ffffffff81120900>] ? d_kill+0x5c/0x7c
[ 1500.467307] Out of memory: kill process 6304 (kdeinit4) score 993142
or a child
[ 1500.467316] Killed process 6478 (kio_http)
[ 1500.780222] akregator invoked oom-killer: gfp_mask=0x201da, order=0,
oomkilladj=0
[ 1500.780239]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
[ 1500.796280] Out of memory: kill process 6304 (kdeinit4) score 966331
or a child
[ 1500.796290] Killed process 6484 (kio_http)
[ 1501.065374] syslog-ng invoked oom-killer: gfp_mask=0x201da, order=0,
oomkilladj=0
[ 1501.065390]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
[ 1501.080579] Out of memory: kill process 6304 (kdeinit4) score 939434
or a child
[ 1501.080587] Killed process 6486 (kio_http)
[ 1501.381188] knotify4 invoked oom-killer: gfp_mask=0x201da, order=0,
oomkilladj=0
[ 1501.381204]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
[ 1501.396338] Out of memory: kill process 6304 (kdeinit4) score 912691
or a child
[ 1501.396346] Killed process 6487 (firefox-bin)
[ 1502.661294] icedove-bin invoked oom-killer: gfp_mask=0x201da,
order=0, oomkilladj=0
[ 1502.661311]  [<ffffffff810d6dd7>] ? oom_kill_process+0x9a/0x264
[ 1502.676563] Out of memory: kill process 7580 (test) score 708945 or a
child
[ 1502.676575] Killed process 7580 (test)


> Can you explain why Xorg is preferred as a baseline to kill rather than 
> krunner in your example?

Krunner is a small app for running other apps and do similar things. It
shouldn't use a lot of memory. OTOH, Xorg has to hold all the pixmaps
and so on. That was expected result. Fist Xorg, then firefox and
thunderbird.


