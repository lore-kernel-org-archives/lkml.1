Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbZKINGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbZKINGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 08:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbZKINGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 08:06:01 -0500
Received: from smtp-out.google.com ([216.239.45.13]:45370 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZKINGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:06:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=OH2i+QklORJ7bCkBizxQH/eQ+WZAYbVdTA/tdYrgugdG2p5DNFBq+unJSq1iuTtK1
	Ak7jkduQLaNeUxojT0ndw==
MIME-Version: 1.0
In-Reply-To: <20091109111154.GB8750@elf.ucw.cz>
References: <20091109111154.GB8750@elf.ucw.cz>
Date: Mon, 9 Nov 2009 05:06:01 -0800
Message-ID: <a55d774e0911090506r4baf53edpc0c5de35defcb96d@mail.gmail.com>
Subject: Re: htc dream: attempts at mmc and framebuffer support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 9, 2009 at 3:11 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> I tried to get mmc and framebuffer to work, but could not. framebuffer
> probably needs clock framework to work properly...

Both fb and mmc will need operable clock control to function.  mmc
will also need the vreg code (to adjust power to the sdcard slot).
Both clk_* and vreg_* are already in, though I haven't put them
through their paces in the latest kernel tree.  They both just wrap
proc_comm (as the modem owns both clock and power control) and are
pretty simple -- they should "just work".

The framebuffer is "fun" to bootstrap -- it needs the mddi transport
(serial video interface), mddi-to-lcdc bridge and panel init code, and
the mdp dma code to go.

Brian
