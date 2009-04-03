Return-Path: <linux-kernel-owner+w=401wt.eu-S1761690AbZDCAXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761690AbZDCAXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZDCAXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:23:06 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:50508 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZDCAXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:23:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=nWZw2+/vnVrpowDUO7wTDvIK+EAtN7dk9Ss8vPBWfWM2ete5DJG/kSMxWVcxTBpSIm
         N/csuEWaMGos3Czfx4mIzK5vtNHEXxzfcbrVD/Gb37lX0Hdiogyqk7+A//WAnNSanGho
         wIxbzwvKz411IwQQftRfyvS1FJzw9HQyGhohA=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Date: Fri, 3 Apr 2009 02:22:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200904011155.20751.a.miskiewicz@gmail.com> <20090402210451.GA4076@elte.hu> <200904022328.02088.rjw@sisk.pl>
In-Reply-To: <200904022328.02088.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904030222.57469.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 of April 2009, Rafael J. Wysocki wrote:
> On Thursday 02 April 2009, Ingo Molnar wrote:
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Thursday 02 April 2009, Chris Wright wrote:
> > > > * Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > > > > Sorry for the misunderstanding, I thought the breakage might be
> > > > > introduced between 15f7176eb1cccec0a332541285ee752b935c1c85 and
> > > > > 0a0c5168df270a50e3518e4f12bddb31f8f5f38f, so I thought it would be
> > > > > a good idea to verify if 0a0c5168df270a50e3518e4f12bddb31f8f5f38f
> > > > > fails too.
> > > >
> > > > Ah, sure.  It fails too (both test_suspend=mem and regular
> > > > suspend/resume).
> > >
> > > Having looked at the commit the Arek's bisect turned up I don't
> > > think it's likely to have caused this problem to appear.
> > >
> > > It seems that the regression had been introduced before the PM and
> > > PCI updates went it, so I bet it's one of the x86 changes.  Ingo,
> > > are there any commits obviously worth testing?
> >
> > i lost context - a list/range of commits to check would be nice.
>
> So far we know that d54b3538b0bfb31351d02d1669d4a978d2abfc5f is good
> (according to Arek) and 0a0c5168df270a50e3518e4f12bddb31f8f5f38f (that
> doesn't introduce functional changes) is already bad (according to Chris).

What about 9ea09af3bd3090e8349ca2899ca2011bd94cda85 ?

stop_machine: introduce stop_machine_create/destroy.

git bisect start
# bad: [14a959101e166abd4165f5a53db5f3dbe4e16fb9] Blackfin arch: add sdh support for bf518f-ezbrd
git bisect bad 14a959101e166abd4165f5a53db5f3dbe4e16fb9
# good: [29881c4502ba05f46bc12ae8053d4e08d7e2615c] Revert "CRED: Fix regression in cap_capable() as shown up by sys_faccessat() [ver #2]"
git bisect good 29881c4502ba05f46bc12ae8053d4e08d7e2615c
# good: [7a1fcd5f5130f173b5e824135735ec58f245563e] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6
git bisect good 7a1fcd5f5130f173b5e824135735ec58f245563e
# bad: [40d7ee5d162203b40b5f4fbb312ab016edddb97f] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6
git bisect bad 40d7ee5d162203b40b5f4fbb312ab016edddb97f
# bad: [7ec7fb394298c212c30e063c57e0aa895efe9439] samples: mark {static|__init|__exit} for {init|exit} functions
git bisect bad 7ec7fb394298c212c30e063c57e0aa895efe9439
# bad: [8e128ce3318a147903c893de1891f6c2306f8a61] Merge branch 'for-next' of git://git.o-hand.com/linux-mfd
git bisect bad 8e128ce3318a147903c893de1891f6c2306f8a61
# good: [c58bd34d00e04df9a0691732086cf8102b20d907] Merge branch 'i2c-next' of git://aeryn.fluff.org.uk/bjdooks/linux
git bisect good c58bd34d00e04df9a0691732086cf8102b20d907
# good: [0931a4c6dbfab03f2bfd22a9170130f7b155d53a] mfd: dm355evm msp430 driver
git bisect good 0931a4c6dbfab03f2bfd22a9170130f7b155d53a
# good: [0578c3b4d44c34e499e1fd5916ed6c63635b25cf] Merge branch 'core-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 0578c3b4d44c34e499e1fd5916ed6c63635b25cf
# bad: [9ea09af3bd3090e8349ca2899ca2011bd94cda85] stop_machine: introduce stop_machine_create/destroy.
git bisect bad 9ea09af3bd3090e8349ca2899ca2011bd94cda85
# good: [d1e99d7ae4e6bbd1ebb5e81ecd3af2b8793efee0] module: fix warning of unused function when !CONFIG_PROC_FS
git bisect good d1e99d7ae4e6bbd1ebb5e81ecd3af2b8793efee0
# good: [c298be74492bece102f3379d14015638f1fd1fac] parisc: fix module loading failure of large kernel modules
git bisect good c298be74492bece102f3379d14015638f1fd1fac
# good: [c298be74492bece102f3379d14015638f1fd1fac] parisc: fix module loading failure of large kernel modules
git bisect good c298be74492bece102f3379d14015638f1fd1fac
# good: [c298be74492bece102f3379d14015638f1fd1fac] parisc: fix module loading failure of large kernel modules
git bisect good c298be74492bece102f3379d14015638f1fd1fac


Unfortunately reverting
9ea09af3bd3090e8349ca2899ca2011bd94cda85
a0e280e0f33f6c859a235fb69a875ed8f3420388
9e01892c4234070bbcf3a9f582514c8b91464375
from master didn't help. 

Two separate bugs, git bisect led me nowhere again or something else?

>
> Thanks,
> Rafael


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

