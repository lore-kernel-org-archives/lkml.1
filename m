Return-Path: <linux-kernel-owner+w=401wt.eu-S1760468AbXKMEk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468AbXKMEk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 23:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbXKMEkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 23:40:15 -0500
Received: from ozlabs.org ([203.10.76.45]:55515 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbXKMEkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 23:40:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Subject: Re: [PATCH] module loader should not complain about unknown symbol
Date: Tue, 13 Nov 2007 15:40:06 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Jan Glauber" <jang@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Pavel Emelyanov" <xemul@openvz.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Jon Masters" <jonathan@jonmasters.org>
References: <1194877107.5656.31.camel@localhost.localdomain> <200711131352.23244.rusty@rustcorp.com.au> <804dabb00711122008t3baa8abbr81ef8ec37e8016a1@mail.gmail.com>
In-Reply-To: <804dabb00711122008t3baa8abbr81ef8ec37e8016a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711131540.07211.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007 15:08:35 Peter Teoh wrote:
> On Nov 13, 2007 10:52 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Tuesday 13 November 2007 09:23:12 Rusty Russell wrote:
> > > Better might be to put in a waitqueue and wake it up whenever a module
> > > is deleted or changes status.  Then use_module() can wait if
> > > strong_try_module_get() returns -EBUSY (up to 30 seconds, then print a
> > > warning and fail).
>
> Will it ever go into a deadlock (or likewise DOS scenario) if modA dep
> on modB, but modB also dep on modA?

No, only if modB requests modA in its init function.  And then only for 30 
seconds.

modprobe will sort out the A needs B needs A case IIRC.

Cheers,
Rusty.
