Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbXHJFlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbXHJFlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 01:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbXHJFlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 01:41:00 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:55452 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbXHJFk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 01:40:58 -0400
To: 7eggert@gmx.de
CC: bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
In-reply-to: <E1IJFw1-0000j1-FX@be1.lrz> (message from Bodo Eggert on Thu, 09
	Aug 2007 23:52:49 +0200)
Subject: Re: [RFC PATCH 1/4] pass open file to ->setattr()
References: <8Qihj-74G-7@gated-at.bofh.it> <8Qihm-74G-29@gated-at.bofh.it> <8Qihm-74G-27@gated-at.bofh.it> <8Qir2-7gx-25@gated-at.bofh.it> <E1IJFw1-0000j1-FX@be1.lrz>
Message-Id: <E1IJNEX-0000Tt-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 10 Aug 2007 07:40:25 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > This is needed to be able to correctly implement open-unlink-fsetattr
> >> > semantics in some filesystem such as sshfs, without having to resort
> >> > to "silly-renaming".
> >> 
> >> How do you plan to do that?
> > 
> > Easy: the SFTP protocol has stateful opens and defines an FSTAT call.
> 
> Is it possible to reconnect without umounting?

Yes, but open files and in-progress requests are lost at reconnect.

> If yes, the unlinked files would be lost in spite of being opened,
> wouldn't they?

Sure.  Obviously one of the drawbacks of a stateful protocol is that
the server state can't survive a reconnect.

But that sort of reliability has never been the goal of sshfs.  And
even if that was needed, it could probably be much better handled in a
lower layer.

Miklos
