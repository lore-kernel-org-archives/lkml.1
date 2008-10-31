Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYJaIt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYJaIt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 04:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYJaItS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 04:49:18 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58113 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYJaItS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 04:49:18 -0400
To: ncunningham@crca.org.au
CC: stern@rowland.harvard.edu, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu
In-reply-to: <1225403060.6574.10.camel@nigel-laptop> (message from Nigel
	Cunningham on Fri, 31 Oct 2008 08:44:20 +1100)
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
References: <Pine.LNX.4.44L0.0810300955020.2401-100000@iolanthe.rowland.org> <1225403060.6574.10.camel@nigel-laptop>
Message-Id: <E1Kvpgo-00045l-GU@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 31 Oct 2008 09:49:06 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Nigel Cunningham wrote:
> I'm not sure that's true. You see, I'm thinking of this as not that
> different to the problem of unmounting filesystems. There, too, we need
> to unmount in a particular order, and let transactions on each
> filesystem stop cleanly before we can unmount them. Even if there are
> differences, perhaps looking at how we handle unmounting will help with
> handling freezing.

There's nothing magic about umount, it just uses a refcount on the fs.

But umount changes the namespace, that's the big difference.  For
example if a process is accessing path P which has a component inside
the mount, it _will_ get different results before and after the
umount.  This is not acceptable for freezing.

For freezing to work with such a refcounting scheme, we'd have to
count _future_ uses of the fs as well, not just current ones, which is
obviously impossible.

Miklos
