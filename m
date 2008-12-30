Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbYL3MuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbYL3MuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYL3Mt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:49:58 -0500
Received: from vena.lwn.net ([206.168.112.25]:57927 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbYL3Mt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:49:57 -0500
Date: Tue, 30 Dec 2008 05:49:46 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, bfields@fieldses.org,
       xfs-masters@oss.sgi.com
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20081230054946.5b021f4f@tpl>
In-Reply-To: <20081229115706.GA955@uranus.ravnborg.org>
References: <20081229041352.6bbdf57c@tpl>
	<20081229115706.GA955@uranus.ravnborg.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008 12:57:06 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> Rather than open coded mutex how about adding a few helpers to
> set and clear the flags and hide locking there?

There's a couple of problems with that.  One being that SETFL wants to
manipulate a bunch of flags together, so a simple set_flag/clear_flag
interface won't do it.  Beyond that, though, calls to the ->fasync()
function need to be atomic with respect to changes to the associated
flag.

Still, it seems that the global lock approach isn't too popular, so
I'll get back to the drawing board once I'm theoretically not on
vacation.

Thanks,

jon
