Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbZHQBhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbZHQBhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 21:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbZHQBhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 21:37:17 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:60382 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZHQBhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 21:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BLOzxnu6zReOCx5aV7BeuHulK1WiamgTjvBDMJ3N5XbPheBOSD7GekNSXR7t+NEcVR
         KhhwA/TM3ML7R4ffFnVP7oyA0rMcIXV/HQ/7TPCdgodcSGGQ/Aqd6VDyelnUs/a4fdSP
         yBTtnM6IykP0OwObGV80WXt8QSEAtxTO/RI/E=
Date: Mon, 17 Aug 2009 09:39:33 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: David Wagner <daw@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Security: information leaks in /proc enable keystroke recovery
Message-ID: <20090817013933.GA5039@cr0.nay.redhat.com>
References: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 03:21:27PM -0700, David Wagner wrote:
>
>In a nutshell, they exploit the fact that many files in /proc are
>world-readable yet contain sensitive information that can leak information
>about inter-keystroke timings.  For instance, /proc/$PID/stat reveals the
>ESP and EIP registers of the associated process, and is world-readable.
>/proc/pid/status is also mentioned as revealing information that could
>be exploited in these attacks.
>
>Based on my understanding of their work, it sounds like some of
>the information on those files should perhaps not be world-readable.
>It's not clear to me that it's reasonable for the kernel to reveal ESP,
>EIP, and other sensitive information about process behavior to everyone
>on the same system.


Nope, just make sure EIP, ESP, WCHAN etc. info will not be leaked.


>
>Are folks already aware of these vulnerabilities?

Yes, we have already fixed this in commit f83ce3 by Jake, so EIP, ESP
and WCHAN will not be leaked for non-privileged users.
