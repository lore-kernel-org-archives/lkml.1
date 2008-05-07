Return-Path: <linux-kernel-owner+w=401wt.eu-S1758427AbYEGUK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbYEGUK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758101AbYEGUKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:10:30 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52597 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828AbYEGUK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:10:27 -0400
Date: Wed, 7 May 2008 22:10:26 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Morten Welinder <mwelinder@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Deleting large files
In-Reply-To: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0805072208140.30395@fbirervta.pbzchgretzou.qr>
References: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-05-07 21:49, Morten Welinder wrote:

>Hi there,
>
>deleting large files, say on the order of 4.6GB, takes approximately forever.
>Why is that?  Well, it is because a lot of things need to take place to free
>the formerly used space,

Only for a few filesystems which use that sort of housekeeping.

>but my real question is "why does the unlink caller have to wait for it?"

Same reason your shell waits for your program to complete before
showing the prompt again?

>I.e., could unlink do the directory changes and then hand off the rest of the
>task to a kernel thread?

Say you had one realtime application running that would do lots of new
writes after the unlink finished. When the unlink is put into the
background, you interleave the unlink operation with new writes,
probably causing needless seeks and therefore not hitting the deadlines
anymore.

For you desktop use, `rm -f foobar.avi &` should do. No?
