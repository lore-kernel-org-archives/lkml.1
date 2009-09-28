Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbZI1TIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbZI1TIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 15:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZI1TIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 15:08:44 -0400
Received: from [195.41.46.235] ([195.41.46.235]:45042 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZI1TIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 15:08:43 -0400
Date: Mon, 28 Sep 2009 21:08:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: 32-rc1: "CROSS_COMPILE changed" message breaks compilation
Message-ID: <20090928190841.GA12004@merkur.ravnborg.org>
References: <20090928175605.GB28514@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928175605.GB28514@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 07:56:05PM +0200, Pavel Machek wrote:
> Hi!
> 
> After update to 2.6.32-rc1, I'm getting
> 
> "Makefile:197: *** CROSS_COMPILE changed from "ccache" to to "ccache ". Use "make mrproper" to fix it up. Stop.
> 
> Note that the message has typo in it ("to to")... What is worse, the
> message triggers even when I try to run make mrproper. Ouch.

The massage is changed in kbuild-fixes.git - but it addresses only ARCH=

As a followup to your other mails:
The reason to use "make mrproper" is that when ARCH or CROSS_COMPILE changes
you have generally either decided to build for a new architecture or
you have changed the way you build the kernel (new toolchain or whatever).
So to clean up using "make mrproper" is perfectly justified.

The target group that uses CROSS_COMPILE to enable ccache are using
CROSS_COMPILE is a way it is not designed for so they should expect that it
is not a perfect match.

We cannot keep a lot of files around for the ccache folks when we for the
"build for a new arch" folks need to remove them all.

I will look into improving the message when CROSS_COMPILE changes.

	Sam
