Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717Ab0ALSa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0ALSa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150Ab0ALSa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:30:57 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:44223 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0ALSa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:30:56 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Date: Tue, 12 Jan 2010 18:30:56 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hiif50$l7r$1@taverner.cs.berkeley.edu>
References: <201001111007.EAG82373.VHFQSLFOFMOOJt@I-love.SAKURA.ne.jp> <20100111174922.GA17285@us.ibm.com>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1263321056 21755 128.32.153.193 (12 Jan 2010 18:30:56 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Tue, 12 Jan 2010 18:30:56 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
>Michael, I'm sorry, I should go back and search the thread for the
>answer, but don't have time right now - do you really need
>disablenetwork to be available to unprivileged users?

I don't know about Michael's specific case, but answering more
broadly, Yes.  There are important use cases for disablenetwork for
unprivileged users.  Basically, it facilitates privilege separation,
which is hard to do today.  A privilege-separated software architecture
is useful for a broad variety of programs that talk to the network --
some/many of which are unprivileged.  For instance, the very original
post on this topic referred to a proposal by Dan Bernstein, where Dan
points out that (for instance) it would make be useful if we could start
a separate process for decompression (or image file transformation),
running that separate process with no privileges (including no network
access) to reduce the impact of vulnerabilities in that code.  Think
of, say, a browser that needs to convert a .jpg to a bitmap; that
would be an example of an unprivileged program that could benefit
from the disablenetwork feature, because it could spawn a separate
process to do the image conversion.
