Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbYDWIer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbYDWIer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 04:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbYDWIej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 04:34:39 -0400
Received: from aug.linbit.com ([212.69.162.22]:39140 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751094AbYDWIei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 04:34:38 -0400
X-Greylist: delayed 1664 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Apr 2008 04:34:37 EDT
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Unexport of blk_get_queue and blk_put_queue
Date: Wed, 23 Apr 2008 10:06:46 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Lars Ellenberg" <lars.ellenberg@linbit.com>
References: <e2e108260804180443s429e0db7j3a48056088634ed9@mail.gmail.com> <20080421122413.GD6011@cs181133002.pp.htv.fi> <e2e108260804222312u673df0bbic3e30089f1d4a238@mail.gmail.com>
In-Reply-To: <e2e108260804222312u673df0bbic3e30089f1d4a238@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804231006.47363.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 23. April 2008 08:12:41 schrieb Bart Van Assche:
> On Mon, Apr 21, 2008 at 2:24 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Fri, Apr 18, 2008 at 01:43:17PM +0200, Bart Van Assche wrote:
> >  > I noticed that blk_get_queue and blk_put_queue were unexported in the
> >  > 2.6.25 kernel. Are you aware that this breaks DRBD (an out-of-tree
> >  > kernel module) ?
> >
> >  no, I verify that my patches don't break Linus' tree and often also peek
> >  at -mm, but not at external modules.
> >
> >  And I'm a proponent of "no stable kernel API, but as many external
> >  modules as reasonably possible should be part of the kernel", so emails
> >  like yours are always a good point to start asking why the code isn't in
> >  Linus' tree.
> >
> >  What happened to DRBD?
> >  It didn't seem that far from getting merged half a year ago.
>
> You mean this message: http://lkml.org/lkml/2007/7/21/255 ?
> (Added Lars Ellenberg in CC.)

Hi,

The removal of blk_put_queue() broke DRBD as it was, but it turned out
that we can (and should) use blk_cleanup_queue() instead. That will be
release with drbd-8.0.12, which is scheduled for release tomorrow 
2008-4-24.

Regarding the kernel inclusion. Well yes we still want to go that road,
but we where distracted from that with other tasks.

 (At some point we even hoped that Adrian will be of help in that process
  but that did not worked out as we thought)

We will renew our effort for main line inclusion in the next months somewhen.

-Phil
-- 
: Dipl-Ing Philipp Reisner                      Tel +43-1-8178292-50 :
: LINBIT Information Technologies GmbH          Fax +43-1-8178292-82 :
: Vivenotgasse 48, 1120 Vienna, Austria        http://www.linbit.com :
