Return-Path: <linux-kernel-owner+w=401wt.eu-S1758949AbZBRXFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbZBRXFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 18:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbZBRXEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 18:04:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44578 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203AbZBRXEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 18:04:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFD] Automatic suspend
Date: Thu, 19 Feb 2009 00:04:17 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902162156380.24097-100000@netrider.rowland.org> <200902182217.48321.rjw@sisk.pl> <d6200be20902181435o1794007bpfbab1f9e41979bad@mail.gmail.com>
In-Reply-To: <d6200be20902181435o1794007bpfbab1f9e41979bad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902190004.18878.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009, Arve Hjønnevåg wrote:
> On Wed, Feb 18, 2009 at 1:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday 18 February 2009, Arve Hjønnevåg wrote:
> >> On Tue, Feb 17, 2009 at 3:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Tuesday 17 February 2009, Alan Stern wrote:
> 
> >> >> Kernel wakelocks are a separate matter.  They are more like a form of
> >> >> optimization, preventing the kernel from starting an auto-suspend when
> >> >> some driver knows beforehand that it will return -EBUSY.
> >> >
> >> > I think kernel-side autosuspend (or rather autosleep) should only happen
> >> > after certain subset of devices have been suspended using a per-device
> >> > run-time autosuspend mechanism.
> >>
> >> When the last wakelock is released the task that we woke up to perform
> >> has finished. Why wait to re-enter suspend.
> >
> > I don't really understand this comment.  Could you please explain a bit?
> 
> If some devices are autosuspended after a local inactivity timeout, I
> don't want to wait for those devices to autosuspend if I know the code
> that needed to run is done. This could cause delays in the normal
> case,

Isn't it a matter of adjusting the inactivity timeouts in a suitable way?

> and it could prevent suspend if a background process (not using
> wakelocks) is accessing a disk more frequently than its idle timeout.

Well, actually, shouldn't it prevent suspend from happening?  Arguably, it just
means that the disk is continuously being accessed with respect to the inactive
timeout granularity.

Rafael
