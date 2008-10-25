Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYJYVXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYJYVXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 17:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYJYVXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:23:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42796 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYJYVXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:23:39 -0400
Message-ID: <49038E40.2070300@zytor.com>
Date: Sat, 25 Oct 2008 14:23:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Robert Moss <robert.von.moss@gmail.com>
CC: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, alistair@devzero.co.uk
Subject: Re: Framebuffer issues in 2.6.26 with uvesafb and vesafb. Linux is
 about choice!
References: <6ffd69180810230054s3b6aff5y880a898c3fc66a37@mail.gmail.com>	 <20081023080459.GC5073@const.bordeaux.inria.fr>	 <6ffd69180810230421v1508664bgc6e454cde792154f@mail.gmail.com>	 <20081024092418.GA10246@const.bordeaux.inria.fr> <6ffd69180810251322n350b6f6dqf496d7e5972165f5@mail.gmail.com>
In-Reply-To: <6ffd69180810251322n350b6f6dqf496d7e5972165f5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Moss wrote:
> ok, this morning, I turned on my computer, and it gave me the error
> message again:
> 
> Undefined video mode number: 317

Your VESA BIOS seems to have some serious braindamage (the fact that the 
modes don't list at all is evidence of that), but finding out what can 
be done to help it would be useful.

Again, a git bisect between v2.6.24 and v2.6.26 would be best:

git clone \
     git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
cd linux-2.6.git
git bisect start
git bisect bad v2.6.26
git bisect good v2.6.24
<build and test kernel>
git bisect <good,bad>
<keep going until one commit shows up>

If a commit doesn't build or otherwise exhibit a different problem 
(meaning "no info available"), use "git bisect skip".

	-hpa
