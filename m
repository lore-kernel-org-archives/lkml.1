Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZLEXLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZLEXLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 18:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbZLEXLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 18:11:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40706 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757927AbZLEXLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 18:11:09 -0500
Date: Sat, 5 Dec 2009 23:13:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: miklos@szeredi.hu, luto@mit.edu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
Message-ID: <20091205231304.03a4af61@lxorguk.ukuu.org.uk>
In-Reply-To: <E1NH1MB-0007v8-Ps@pomaz-ex.szeredi.hu>
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
	<20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>
	<E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu>
	<20091202204828.4fa0c108@lxorguk.ukuu.org.uk>
	<E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu>
	<4B1A7159.3070101@mit.edu>
	<E1NH0Ub-0007oy-43@pomaz-ex.szeredi.hu>
	<20091205202838.3456b6fc@lxorguk.ukuu.org.uk>
	<E1NH1MB-0007v8-Ps@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Dec 2009 21:35:55 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Sat, 5 Dec 2009, Alan Cox wrote:
> > I am concerned primarily about the lack of ability to get rid of such a
> > handle in a controlled fashion. The udev/device unload case is simply one
> > obvious way to exploit it.
> 
> I don't understand your concern.  Can you please ellaborate on the way
> to exploit O_NODE?

You end up with a handle to an object which then changes meaning if a
device is unloaded and something else loaded (or consider a pty
recreation)

In the normal udev course of things this is ok because even without
revoke udev can just about get away with it for the sole reason it knows
that the handle cannot be open in any form during the driver unload
(because of the device refcounting). You seem to break that.

