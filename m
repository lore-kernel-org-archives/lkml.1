Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZJ0RMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZJ0RMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbZJ0RMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:12:45 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40394 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbZJ0RMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:12:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:x-age:x-location
         :x-os:x-face:content-type:content-transfer-encoding;
        b=iG25sbXzeDx2jJ1dkcImBSri1DJxtUqW+rIlfJmCoXzypbzc0wUVGKqfl9ztOCfXG7
         alFqv/OQrsigr5xpZP9lz/3GwhwMSsu/VN0zSdKopR6VbfeWBhaTB3Uq4jJyBPSWdOcz
         LKC9KQ0PNsEIGIi4hL2k3H5BI5X3fZfvYg0FU=
Message-ID: <4AE72A0D.9070804@gmail.com>
Date: Tue, 27 Oct 2009 18:12:45 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       hugh.dickins@tiscali.co.uk, akpm@linux-foundation.org,
       rientjes@google.com
Subject: Re: Memory overcommit
References: <hav57c$rso$1@ger.gmane.org>	<20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com>	<hb2cfu$r08$2@ger.gmane.org>	<20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com>	<4ADE3121.6090407@gmail.com>	<20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>	<4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
X-Age: 25
X-Location: Lovran, Croatia
X-OS: Debian GNU/Linux
X-Face: +Lg7^E:?#]P.Y{N@61yW{aY#>fRcOE6MMqgAM|Kwk"fK!y!i4+h6&?E`Jt@uame[-SLu#*<fGtMmVfh8qo,"kJ'ql^Ni?]l|ax{fvvmD<k:2w^e(y8J2YWO`M=u17OWli}Rf^e:|w2]LulgE(:u0|}mNBZFid[YEWAC>?k:)dZv<!'a)N0b=LFDZKY!!@[%mmVO-7y`Nkj?{<C6rm9Uz$EXu;0I<PubM.Po|vlT.2&vPkJG07G.l0Ty)B/dR0k:KU<;?+WAR\f_ms2b~i"g@e}a)i1N$WLBa{vBoDs4!}k\g?lItt=|]=M{Fm@ce|^6PXq&
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:

> On Mon, 26 Oct 2009 17:16:14 +0100
> Vedran Furač <vedran.furac@gmail.com> wrote:
>>>  - Could you show me /var/log/dmesg and /var/log/messages at OOM ?
>> It was catastrophe. :) X crashed (or killed) with all the programs, but
>> my little program was alive for 20 minutes (see timestamps). And for
>> that time computer was completely unusable. Couldn't even get the
>> console via ssh. Rally embarrassing for a modern OS to get destroyed by
>> a 5 lines of C run as an ordinary user. Luckily screen was still alive,
>> oomk usually kills it also. See for yourself:
>>
>> dmesg: http://pastebin.com/f3f83738a
>> messages: http://pastebin.com/f2091110a
>>
>> (CCing to lklm again... I just want people to see the logs.)
>>
> Thank you for reporting and your patience. It seems something strange
> that your KDE programs are killed. I agree.

No problem. I want this to be solved as much as you do. Actually, it is
not strange, just a buggy algorithm.

Run:

% ps -T -eo pid,ppid,tid,vsz,command

You'll see that ppid of a number of processes is kdeinit, gnome-session,
fvwm or something else depending on what one is using. All of this
processes are started automatically during startup or manually clicking
on a menu item or by some keyboard shortcut. OOM algorithm just sums
memory usage of all of them and adds that ot the parent. Just plain wrong.

Also, it seems it's looking at VIRT instead of RES.

> I attached a scirpt for checking oom_score of all exisiting process.
> (oom_score is a value used for selecting "bad" processs.")
> please run if you have time.

96890   21463   VirtualBox // OK
118615  11144   kded4 // WRONG
127455  11158   knotify4 // WRONG
132198  1       init // WRONG
133940  11151   ksmserver // WRONG
134109  11224   audacious2 // Audio player, maybe
145476  21503   VirtualBox // OK
174939  11322   icedove-bin // thunderbird, maybe
178015  11223   akregator // rss reader, maybe
201043  22672   krusader  // WRONG
212609  11187   krunner // WRONG
256911  24252   test // culprit, malloced 1GB
1750371 11318   run-mozilla.sh // tiny, parent of firefox threads
2044902 11141   kdeinit4 // tiny, parent of most KDE apps

> Sigh, gnome-session has twice value of mmap(1G).
> Of course, gnome-session only uses 6M bytes of anon.
> I wonder this is because gnome-session has many children..but need to

Yes it is.

Regards,

Vedran
