Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbYKWE1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbYKWE1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 23:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYKWE1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 23:27:07 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:35997 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696AbYKWE1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 23:27:06 -0500
Message-ID: <4928DBAF.4030209@lougher.demon.co.uk>
Date: Sun, 23 Nov 2008 04:27:27 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Zero-clearing all zero-clearable bytes.
References: <200811221236.FJE81778.LtMHOQFJFVFSOO@I-love.SAKURA.ne.jp>
In-Reply-To: <200811221236.FJE81778.LtMHOQFJFVFSOO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Hello.
> 
> I often create a Live CD.
> When creating a Live CD, loopback mounted ext3 image files are used.
> These image files are then compressed so that the ISO image will fit within
> a CD-R's capacity (i.e. 700MB).
> 

You don't mention what you're using to compress the ext3 image file.  If 
you're using Squashfs then it's much better to zero-fill the blocks 
rather than use 255, because Squashfs detects zero-filled blocks and 
stores them sparsely.  This not only gets slightly better compression 
(than a compressed zero-filled block), but reading is also slightly faster.

Phillip


