Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbZLDQwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbZLDQwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbZLDQwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:52:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:47121 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731AbZLDQwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:52:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,340,1257148800"; 
   d="scan'208";a="752875841"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: Pavel Machek <pavel@ucw.cz>, "Wang, Shane" <shane.wang@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Date: Fri, 4 Dec 2009 08:52:12 -0800
Subject: RE: [PATCH] intel_txt: add s3 userspace memory integrity
	verification
Thread-Topic: [PATCH] intel_txt: add s3 userspace memory integrity
	verification
Thread-Index: Acp0802Py4j62yRQRvmWXc+LBo4VGQADjtQQ
Message-ID: <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4DC@orsmsx506.amr.corp.intel.com>
References: <4B18D26B.4040500@intel.com> <20091204082927.GF1540@ucw.cz>
In-Reply-To: <20091204082927.GF1540@ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pavel Machek [mailto:pavel@ucw.cz]
> Sent: Friday, December 04, 2009 12:29 AM
>
> > This patch added verification for userspace memory integrity after
> >  S3 resume.
>
> It does not work.
>
> > Integrity verification for other memory (say kernel itself) has been done by tboot.
> >
>
> Not true. Kernel  uses memory above 4G on x86-64. Including... say
> console writing functions.

I've responded to that in your previous email thread, so let's keep the technical discussion of what is MAC'ed to just that one thread.

> You can patch holes, but without description 'what does this protect
> against' it is almost impossible to evaluate.
>
>
> > +void tboot_do_suspend_lowlevel(void)
> > +{
> > +   int ret = -1;
> > +
> > +   if (!tboot_enabled()) {
> > +           do_suspend_lowlevel();
> > +           return;
> > +   }
> > +
> > +   ret = tboot_pre_stack_switch();
> > +   if (!ret) {
> > +           tboot_switch_stack_call(tboot_do_suspend_lowlevel_call,
> > +                                   (u64)new_stack_ptr);
>
> ...and here you add requirements to suspend_lowlevel that were not
> there before. ("May not act on unchecksummed memory"), without
> documenting them.

Really the only requirement is (as discussed in the previous thread) that it only use code and data within [_text, _end - _text]--do you think that this really needs to be called out?  do_suspend_lowlevel() is a very simple function that has just the one (resume path) call to another simple function--it doesn't seem likely that it would violate this.

>
> NAK.
>                                                                       Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
