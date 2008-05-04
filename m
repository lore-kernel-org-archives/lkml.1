Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbYEDUX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbYEDUX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 16:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbYEDUXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 16:23:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:24691 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbYEDUXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 16:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Msy3fswJsQrZIflPXXB4hVO73Ise01F4ql7nSyL5YnGfjW7XevzwY2IcR6+dU/YYtkGgZAI0DbGuMjRrVAGJrEYeUnOfk3Y4L6foy1m2MWC+zn4RY2QgCLsq/T7zhn8DslZvz6AURvZRC/yNLQvPb/wbX1kXsONeR2EsgcVe1mw=
Message-ID: <86802c440805041323s1484a8ecx5dbe639d658d015b@mail.gmail.com>
Date: Sun, 4 May 2008 13:23:17 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: [git head] Should X86_PAT really default to yes?
Cc: "Jesse Barnes" <jesse.barnes@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>
In-Reply-To: <200805040910.57088.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805022122.03576.elendil@planet.nl>
	 <924EFEDD5F540B4284297C4DC59F3DEEFB8D3D@orsmsx423.amr.corp.intel.com>
	 <200805021340.24987.jesse.barnes@intel.com>
	 <200805040910.57088.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 12:10 AM, Frans Pop <elendil@planet.nl> wrote:
> On Friday 02 May 2008, Jesse Barnes wrote:
>  > This is just a transient issue during VT switch or server exit though,
>  > right? X functionality isn't affected, and your VTs work fine?
>
>  Transient only. I've just tested again and this time the band
>  was visible on top of the text on VT1 for about 2 seconds. Then it
>  disappeared.
>  The artifacts also appear when I log out from KDE (i.e. without exiting the
>  server), and I also get the messages when logging out and logging in again.
>
>  I do not see any performance issues, but I've only used this kernel for a
>  very short time.
>
>
>  > If so, it might not be a PAT issue but just a different memory layout or
>  > something (and therefore it would really just be a cosmetic bug in the X
>  > driver).
>
>  The artifacts may not be a PAT issue directly, but it is a clear regression
>  for me as I currently have a nice clean screen when X shuts down. I'm also
>  100% sure that it is caused by enabling PAT. A kernel with same config and
>  only PAT disabled does not show the artifacts.
>
>  Would you like me to file a bug against X for these artifacts?
>  If so, against what component? The i810 driver or the server?
>
>
>  On Saturday 03 May 2008, Jesse Barnes wrote:
>  > > I don't see these error messages on my 965 here. May be I have different
>  > > x version.
>
>  > Hm, yeah that could be.  strace would tell us.
>
>  Would you like me to do an strace?
>
>  Attached my Xorg log for basic info (versions are current Debian unstable)
>  and the config I used.
>
>  Also attached a dmesg that shows the messages. As you can see there are some
>  repeats.
>  - first 22 "expected mapping type" when X is started
>  - second 22 "expected mapping type" when logging in
>  - 9 "freeing invalid memtype" when logging out
>  - 22 "expected mapping type" when logging in again
>  - 9 "freeing invalid memtype" when logging out again
>  - last series "expected mapping type" when restarting X server
>
>
>
>  On Saturday 03 May 2008, Jesse Barnes wrote:
>  > More recent versions of X will use sysfs rather than /dev/mem (though
>  > we're still using the mprotect hack there to give us UC-), so yeah this
>  > warning should already be gone in more recent builds.
>
>  On Friday 02 May 2008, Pallipadi, Venkatesh wrote:
>  > ... and should not cause any side-effects other than little annoyance.
>
>
>  On Friday 02 May 2008, Jesse Barnes wrote:
>  > I really think PAT should be on by default; if you're running into real
>  > functional or performance problems we'd better get them fixed rather than
>  > disabling PAT...
>
>  I must say that I'm fairly disappointed by your (plural) attitude to these
>  regressions, especially given that you both seem to feel it is important
>  that people will actually use PAT.
>
>  I would say that 40+ messages each time I start X is more than "a little
>  annoyance", especially if you run logcheck (as I do).
>
>  I also think you both seriously underestimate how it will impact enabling
>  PAT, especially by distributions. Although the errors and the artifacts may
>  be minor from a technical point of view, they are the sort of issues that
>  users file bug reports about. Loads of them!
>  So I expect distros will be extremely reluctant to enable PAT when they know
>  they can expect this. The fact that the messages will go away at some point
>  in the future is absolutely not relevant.
>
>  Add to that the current warning in the Kconfig help:
>    Say N here if you see bootup problems (boot crash, boot hang,
>    spontaneous reboots) or a non-working video driver.
>
>  Do you really think that distros can afford the risk of such issues in their
>  generic kernel images even if it would only affect a small minority of
>  their user base? If this warning is realistic then IMHO X86_PAT should
>  default to N and be marked "experimental".
>
>  You can be sure that I at least will not be enabling X86_PAT in the near
>  future because of these two issues. And given the nature of this option I'm
>  quite likely to completely forget about it afterwards...
>
>
>  That said, I'll be happy to help trace and get these issues fixed.

can you boot with pat=off and send out /proc/mtrr?

YH
