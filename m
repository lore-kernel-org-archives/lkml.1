Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbYH3UUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbYH3UUf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbYH3UU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:20:27 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:53515 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYH3UU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:20:26 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: buffer overflow in /proc/sys/sunrpc/transports
Date: Sat, 30 Aug 2008 20:20:24 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <g9ca28$pak$1@taverner.cs.berkeley.edu>
References: <20080830184422.GA9598@localhost.localdomain>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1220127624 25940 128.32.168.222 (30 Aug 2008 20:20:24 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sat, 30 Aug 2008 20:20:24 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum  wrote:
>I don't know if this could be used in some malicious way. Maybe if a setuid
>root program tried to open a user-supplied file (which could be this one in
>/proc), it could crash the program quite easily. But since there is no way
>to change the contents of the file... I don't know.

You don't necessarily need control over the values that are written past
the end of the buffer to exploit a buffer overrun bug.  If those values
are semi-random but predictable, it may still be possible to exploit the
vulnerability by arranging to stash malicious code at the address that the
return address will be overwritten with.  Even if those values are random
and not predictable, it may still be able to fill a large fraction of the
address space with malicious code and thus have a significant probability
of successful exploitation.  See, e.g., NOP sleds, heap spraying, heap
feng shui.  I would not want to rely on this bug being difficult to exploit.

Bottom line: I suspect it would be prudent to assume this bug may be
fully exploitable.
