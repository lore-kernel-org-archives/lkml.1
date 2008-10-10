Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbYJJLbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbYJJLbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbYJJLbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:31:24 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:37620 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757892AbYJJLbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:31:23 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: dup2() vs dup3() inconsistency when
To: mtk.manpages@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       Ulrich Drepper <drepper@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Fri, 10 Oct 2008 13:42:11 +0200
References: <bl2EV-7G2-9@gated-at.bofh.it> <bl7v3-5sk-17@gated-at.bofh.it> <blasN-OS-9@gated-at.bofh.it> <blaCu-Z0-11@gated-at.bofh.it> <blaMj-18o-23@gated-at.bofh.it> <blaMj-18o-21@gated-at.bofh.it> <bliqg-2DH-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KoGNo-0001bu-C2@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@googlemail.com> wrote:

> Well, as long as we are fixing the dup3() interface in the way that Al
> and Ulrich have suggested, what about another fix:
> 
> give an error if newfd is already open, thus forcing the user to do an
> explicit close
> 
> ?
> 
> This silent close in dup2() is an implementation blemish.  Why not eliminate
> it?

I think it might be usefull:
Thread B does some logging to fd 42
Thread A switches the logfile by creating a new file, writing a header and
then does dup3(fd, 42, O_WRONLY|O_APPEND|O_CLOEXEC); close(fd);

(Off cause this is not yet implemented, O_RDONLY would give some problems,
 O_CLOEXEC alone might be better done while open()ing the file, ... but you
 get the idea.)


BTW: I think dup3(fd, -1, flags) should use the file descriptor dup() would
return. Or should there be a dupf(fd, flags) syscall instead?


