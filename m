Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbXKDX2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbXKDX2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbXKDX22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:28:28 -0500
Received: from gw.goop.org ([64.81.55.164]:50521 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbXKDX21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:28:27 -0500
Message-ID: <472E557E.3010903@goop.org>
Date: Sun, 04 Nov 2007 15:27:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486DX4
References: <200711042259.lA4Mxa0n025210@tazenda.hos.anvin.org> <alpine.LFD.0.999.0711041512530.15101@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0711041512530.15101@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I'm not entirely sure that it needs to be a long-jump, btw. I think any
> regular branch is sufficient. You obviously *do* need to make the long 
> jump later (to reload %cs in protected mode), but I'm not sure it's needed 
> in that place. I forget the exact rules (but they definitely were 
> documented).

Yes, it says it needs to be a far jmp or call (and if you enabled paging
in the cr0 load, you need to identity-map the branch target).  Having
successfully broken the rules for a long time so far, maybe we can get
away with still cutting corners...  but it doesn't seem particularly
worthwhile since we've been caught once.

    J
