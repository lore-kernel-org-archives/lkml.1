Return-Path: <linux-kernel-owner+w=401wt.eu-S935896AbXHHS6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935896AbXHHS6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbXHHS6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:58:19 -0400
Received: from [212.12.190.253] ([212.12.190.253]:32987 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751135AbXHHS6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:58:18 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-ide@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
Date: Wed, 8 Aug 2007 21:58:32 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082158.32806.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo  wrote:
> Mark Lord wrote:
> > Heh.. I haven't instrumented it yet, but I did discover a bit more about
> > it:
> >
> > The Power-Off_Retract_Count incrmenents *only* when there's data in the
> > on-drive write-cache.  So if I haven't written anything significantly
> > large before suspending, then it often does NOT increment the retract
> > counter.
> >
> > But if I copy a couple of multi-MB files around and then suspend (to
> > RAM), the retract count gets incremented.
> >
> > So I've now just stuck "hdparm -F /dev/sda" into my suspend script,
> > and that cures the problem completely for me.  "-F" does a FLUSH_CACHE,
> > and requires a recent copy of hdparm.
> >
> > Perhaps libata should also do a FLUSH_CACHE before any STANDBYNOW
> > command, prior to entering STR, which is what my script is currently now
> > doing..
> >
> > I'll instrument libata and see what the current sequence is.
>
> Hmmmm.. libata should issue FLUSH CACHE on STR too.  sd_suspend() and
> sd_shutdown() are pretty similar after all.

IMHO, this is a mess because we are essentially trying to work around 
firmware bugs, which may only be solved by having the kernel load a 
user-supplied shutdown sequence, instead of hardcoding it into the kernel.


Thanks!

--
Al

