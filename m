Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbZIFOXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbZIFOXP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 10:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757952AbZIFOXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 10:23:13 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:53049 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951AbZIFOXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 10:23:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l0q6f44b2u1iBGBq9tRSjdAl2vTt9r/jqxCSgrW7o3nksjaUK+/whxOSkqnj7ghy+P
         bV81G61eZVsp2W4PR6Fz7nNfXxgj2M65Mf7qNebw4IfyXYcnc3Zw381kXn5deimo3jO7
         ndDcFJCzObxru5k0ecstYnAlDevCPwTmeSfNk=
Date: Sun, 6 Sep 2009 16:22:06 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ling.ma@intel.com
Subject: [Bisected] Output to external monitor is broken (Re: Linux
	2.6.31-rc9)
Message-ID: <20090906142206.GA4449@Pilar.aei.mpg.de>
References: <alpine.LFD.2.01.0909051645430.3329@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909051645430.3329@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat  5.Sep'09 at 16:54:27 -0700, Linus Torvalds wrote:
> Go wild, and please give this a final round of testing.

The output from my Vaio laptop to the external monitor (LG Flatron M228WD) 
is broken now. The screen is all messed-up once the boot messages from the
kernel appear on it (see the picture at the link below).

I bisected it down to f8aed700c6ec46ddade6570004ce25332283b306 ("drm/i915:
Set crtc/clone mask in different output devices"). I doubled checked
that reverting this commit from 2.6.31-rc9 fixes the problem.

The picture of the bad output is here:
http://www.aei.mpg.de/~crmafra/bad_output.jpg

as well as my config:
http://www.aei.mpg.de/~crmafra/config-2.6.31-rc9.txt

and dmesg (with the above commit reverted):
http://www.aei.mpg.de/~crmafra/dmesg-2.6.31-rc9+revert.txt

(the vga=0x0364 in the command line does not work since I
enabled KMS, so I get a prompt in the beginning from which I 
choose vga=0. But the above regression is not affected by this
choice because the command line was always the same during 
bisection)

If there is anything else I can do, just let me know.




