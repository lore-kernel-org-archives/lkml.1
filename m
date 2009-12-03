Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbZLCFqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbZLCFqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 00:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZLCFqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 00:46:33 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47656 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZLCFqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 00:46:33 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20091202204828.4fa0c108@lxorguk.ukuu.org.uk> (message from Alan
	Cox on Wed, 2 Dec 2009 20:48:28 +0000)
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
	<20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>
	<E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu> <20091202204828.4fa0c108@lxorguk.ukuu.org.uk>
Message-Id: <E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 03 Dec 2009 06:46:27 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Dec 2009, Alan Cox wrote:
> > You're still missing the point.  O_NODE is like a hard link, except
> > the reference doesn't come from the filesystem but from a file
> > descriptor.  From udev's perspective there's no difference.
> 
> I don't think I am missing the point here. You have a reference to an
> object in the fs but you don't have a reference to the driver underneath
> s the driver can change on you *while* you have the O_NODE open and fd
> live. That cannot happen with a hard link and open.
> 
> It isn't the same thing as far as I can see. You don't have the barrier
> between the operations that occurs in the real open/close case because
> they lock the driver.

The file descriptor opened with O_NODE allows exaclactly the same
operations that a hard link to the device would, nothing more.  It's
just a link to the *node*, except it doesn't increment the link count,
the driver is irrelevant.

Miklos
