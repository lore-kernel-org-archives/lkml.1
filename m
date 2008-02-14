Return-Path: <linux-kernel-owner+w=401wt.eu-S1763404AbYBNTIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763404AbYBNTIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758117AbYBNTIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:08:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480AbYBNTIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:08:23 -0500
Date: Thu, 14 Feb 2008 11:05:01 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Norbert Preining <preining@logic.at>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org,
       USB development list <linux-usb@vger.kernel.org>
Subject: Re: Huawei E220 and usb storage
Message-Id: <20080214110501.ec400e10.zaitcev@redhat.com>
In-Reply-To: <20071116132256.GA19251@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at>
	<20071030211729.6a80a93a.Kristoffer.ericson@gmail.com>
	<20071030204720.GI8479@gamma.logic.tuwien.ac.at>
	<47279EF7.3040406@redhat.com>
	<20071030212213.GA13410@gamma.logic.tuwien.ac.at>
	<20071030152816.f2e8dd7c.zaitcev@redhat.com>
	<20071031061552.GH11722@gamma.logic.tuwien.ac.at>
	<20071116132256.GA19251@gamma.logic.tuwien.ac.at>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007 14:22:56 +0100, Norbert Preining <preining@logic.at> wrote:

> > > The difference with huaweiAktBbo.c seems that kernel uses a nonzero length.
> > > Can you try zero length with the kernel? It's the second argument to the last.
> > 
> > I tried with the git patch plus changing the penultimage argument from
> > 0x1 to 0.
> 
> Ok, did new tests with 2.6.24-rc2:
> - with plain kernel the usb-storage modules attaches and detaches
>   permanently a virtual cd drive, I stopped after 30+ iterations.

It looks like between Dave Russel and I, we hit the same problem
that you did, after taking care of detection and initialization.
Look at his dmesg in comment #44 in this:
 https://bugzilla.redhat.com/show_bug.cgi?id=253096#c44

> - changing the penultimage argument in the usb_stor_huawei_e220_init
>   function from 0x1 to 0 stopped this misbehaviour, but
> 
> - with the change from 0x1 to 0 the initialization works automatically.

I may be able to test this.

As you recall, Huawei people themselves suggested nonzero length,
this is why we didn't want to change it. But perhaps they are
mistaken about the operation of their own hardware. Stranger
things happened...

-- Pete
