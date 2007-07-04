Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbXGDOey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbXGDOey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759529AbXGDOes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:34:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49509 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759411AbXGDOer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:34:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 16:41:58 +0200
User-Agent: KMail/1.9.5
Cc: paulus@samba.org, mjg59@srcf.ucam.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070703211227.GA28758@srcf.ucam.org> <200707041325.55779.rjw@sisk.pl> <E1I63Nv-0006Z9-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I63Nv-0006Z9-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041641.58883.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 4 July 2007 13:51, Miklos Szeredi wrote:
> > Still, my position is this:
> > 
> > 1) The freezer (in the modified form, with the freezing of kernel threads
> > limited to the ones that want to be frozen) is needed for hibernation.
> > 
> > 2) The freezer is generally not needed for suspend, _but_ there are drivers
> > in the tree that rely on it being used.  Thus, at some point in time we can
> > remove the freezer from the suspend code path, _but_ no sooner than we are
> > sure that the majority of drivers is prepared for that.
> 
> And we won't know if drivers are OK until we remove the freezer,
> catch-22.

I disagree.  We can learn that by auditing the drivers.

> So I think we need to disable the freezer at least in -mm and/or
> optionally in -linus.
> 
> I applied Matthew's patch, and suspend did in fact stop working
> (thinkpad t60), but there was nothing catastrophic.  Here's the dmesg
> if somebody is interested:
> 
> Suspending console(s)
> usb_endpoint usbdev5.3_ep83: PM: suspend 0->2, parent 5-2:1.0 already 2
> usb_endpoint usbdev5.3_ep02: PM: suspend 0->2, parent 5-2:1.0 already 2
> usb_endpoint usbdev5.3_ep81: PM: suspend 0->2, parent 5-2:1.0 already 2
> hub 2-0:1.0: suspend error -16
> suspend_device(): usb_suspend+0x0/0x1c() returns -16
> Could not suspend device usb2: error -16
> usb_endpoint usbdev5.3_ep81: PM: resume from 0, parent 5-2:1.0 still 2
> usb_endpoint usbdev5.3_ep02: PM: resume from 0, parent 5-2:1.0 still 2
> usb_endpoint usbdev5.3_ep83: PM: resume from 0, parent 5-2:1.0 still 2
> Some devices failed to suspend

No, it's not catastrophic, but something like this will result in a bug report
with "regression" in the subject.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
