Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbZLBUOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbZLBUOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZLBUOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:14:16 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55260 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbZLBUOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:14:15 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: miklos@szeredi.hu, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       dhowells@redhat.com, hch@infradead.org, adilger@sun.com,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, jamie@shareable.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20091202191549.1dbffa2e@lxorguk.ukuu.org.uk> (message from Alan
	Cox on Wed, 2 Dec 2009 19:15:49 +0000)
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu> <20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>
Message-Id: <E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 Dec 2009 21:13:46 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Dec 2009, Alan Cox wrote:
> > 1) There's a security hole with dynamicly allocated devices if
> > permissions on new device are difference than on old device.
> > 
> > The issue is valid, but also exists if hard links are created to
> > device nodes.  udev already defends against this by setting
> > permissions on device to zero before unlinking it.
> 
> udev defends against it with the specific knowledge that any existing
> open means the device is open and cannot be unloaded. The combination is
> required (and some other happenstance properties).

You're still missing the point.  O_NODE is like a hard link, except
the reference doesn't come from the filesystem but from a file
descriptor.  From udev's perspective there's no difference.

Miklos
