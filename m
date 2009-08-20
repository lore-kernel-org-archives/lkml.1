Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZHTObu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZHTObu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZHTObs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:31:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53502 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbZHTObr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:31:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv3 2/2] vhost_net: a kernel-level virtio server
Date: Thu, 20 Aug 2009 16:31:36 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, Or Gerlitz <ogerlitz@voltaire.com>
References: <cover.1250187913.git.mst@redhat.com> <200908201510.54482.arnd@arndb.de> <20090820133817.GA7834@redhat.com>
In-Reply-To: <20090820133817.GA7834@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908201631.37285.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18LkPWfEQG+mxqtEEs3Agdux0tJoxucVeUuaWQ
 WJfdMyshafsS54A7/yndnzyeIMRJQZkRN7+ujkEdcyiwYxO2/8
 UO/rBvrsxi8JMhq0+1NBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, Michael S. Tsirkin wrote:
> On Thu, Aug 20, 2009 at 03:10:54PM +0200, Arnd Bergmann wrote:
> > On Thursday 20 August 2009, Michael S. Tsirkin wrote:
>
> It doesn't matter that I don't want this: allowing 1 process corrupt
> another's memory is a security issue.  Once you get an fd, you want to
> be able to use it without worrying that a bug in another process will
> crash yours.

Ok, got it. Yes, that would be inacceptable.

> > > If you assume losing the code for the second error condition is OK, why
> > > is the first one so important?  That's why I used a counter (eventfd)
> > > per virtqueue, on error userspace can scan the ring and poll the socket
> > > and discover what's wrong, and counter ensures we can detect that error
> > > happened while we were not looking.
> > 
> > I guess we were talking about different kinds of errors here, and I'm
> > still not sure which one you are talking about.
> > 
> Non fatal errors. E.g. translation errors probably should be
> non-fatal. I can also imagine working around guest bugs in
> userspace.

Ah, so I guess the confusion was that I was worried about
errors coming from the socket file descriptor, while you
were thinking of errors from the guest side, which I did not
expect to happen.

The errors from the socket (or chardev, as that was the
start of the argument) should still fit into the categories
that I mentioned, either they can be handled by the host
kernel, or they are fatal.

I'll read up in your code to see how you handle asynchronous
non-fatal errors from the guest. Intuitively, I'd still
assume that returning the first error should be enough
because it will typically mean that you cannot continue
without fixing it up first, and you might get the next
error immediately after that.

	Arnd <><
