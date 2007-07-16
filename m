Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbXGPJiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbXGPJiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbXGPJiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:38:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37676 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbXGPJiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:38:06 -0400
Message-ID: <469B3B73.9010400@zytor.com>
Date: Mon, 16 Jul 2007 02:33:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: jeremy@goop.org, jengelh@computergmbh.de, viro@ftp.linux.org.uk,
       nmiell@comcast.net, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: *at syscalls for xattrs?
References: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr> <20070715205313.GE21668@ftp.linux.org.uk> <1184534001.2765.5.camel@entropy> <20070715222323.GG21668@ftp.linux.org.uk> <Pine.LNX.4.64.0707160954160.25352@fbirervta.pbzchgretzou.qr> <469B2CAE.9010101@goop.org> <E1IAMWA-0004fM-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1IAMWA-0004fM-00@dorka.pomaz.szeredi.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> 
> The *at() thing basically gives you the advantages of a CWD without
> the disadvantages.
> 
> For example it could be useful to implement the functionality of
> find(1) as a library interface.
> 

What the *at() interfaces really do is fix/paper over a longstanding
wart in Unix: the cwd really should have been a standard file descriptor
(like stdin/stdout/stderr) instead of a magic piece of state maintained
in kernel space.

If they had been designed-in from the beginning I suspect we wouldn't
have had, say, stat() and fstat(), but simply statat() -- the "normal"
ones would simply be statat(stddir, path) and statat(fd, NULL)
respectively.  Now it isn't quite so clean.

You can do some of that stuff with fchdir(), but *at() is much nicer,
minus the oddball Solaris naming with random presence and absence of f-
prefixes.

	-hpa
