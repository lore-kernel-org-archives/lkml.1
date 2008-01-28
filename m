Return-Path: <linux-kernel-owner+w=401wt.eu-S1764301AbYA1Xyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764301AbYA1Xyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYA1XyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:54:24 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:34802 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYA1XyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:54:23 -0500
Date: Tue, 29 Jan 2008 00:54:22 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/5] Module: check to see if we have a built in module
 with the same name
In-Reply-To: <1201477122-4541-3-git-send-email-gregkh@suse.de>
Message-ID: <Pine.LNX.4.64.0801290052100.1185@fbirervta.pbzchgretzou.qr>
References: <20080127233751.GA4524@kroah.com> <1201477122-4541-3-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 27 2008 15:38, Greg Kroah-Hartman wrote:
>Subject: [PATCH 3/5] Module: check to see if we have a built in module with the
>     same name
>
>When trying to load a module with the same name as a built-in one, a
>scary kobject backtrace comes up.  Prevent that from checking for this
>condition and warning the user as to what exactly is going on.

Should not external modules with internal names be rejected at modprobe 
time? Otherwise I'd wonder how you want to deal with /sys/modules/XXX if 
both modules export some module_param()s.

It's just that if I happen to load vt.ko that the existing 
/sys/modules/vt (from in-kernel vt.o) does not get overwritten by new 
dentries that vt.ko will spawn. Something like /sys/modules/vt.1 perhaps 
for /the new module with same name?
