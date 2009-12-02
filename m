Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZLBUrC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZLBUrC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:47:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZLBUrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:47:01 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35880 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754393AbZLBUrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:47:01 -0500
Date: Wed, 2 Dec 2009 20:48:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
Message-ID: <20091202204828.4fa0c108@lxorguk.ukuu.org.uk>
In-Reply-To: <E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu>
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
	<20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>
	<E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ridiculous cc list cleaned]

> > udev defends against it with the specific knowledge that any existing
> > open means the device is open and cannot be unloaded. The combination is
> > required (and some other happenstance properties).
> 
> You're still missing the point.  O_NODE is like a hard link, except
> the reference doesn't come from the filesystem but from a file
> descriptor.  From udev's perspective there's no difference.

I don't think I am missing the point here. You have a reference to an
object in the fs but you don't have a reference to the driver underneath
s the driver can change on you *while* you have the O_NODE open and fd
live. That cannot happen with a hard link and open.

It isn't the same thing as far as I can see. You don't have the barrier
between the operations that occurs in the real open/close case because
they lock the driver.
