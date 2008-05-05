Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbYEEP6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbYEEP6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYEEP6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:58:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:27542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYEEP6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:58:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,438,1204531200"; 
   d="scan'208";a="278026365"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [git head] Should X86_PAT really default to yes?
Date: Mon, 5 May 2008 08:57:57 -0700
User-Agent: KMail/1.9.9
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>
References: <200805022122.03576.elendil@planet.nl> <200805021340.24987.jesse.barnes@intel.com> <200805040910.57088.elendil@planet.nl>
In-Reply-To: <200805040910.57088.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805050857.57661.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 04, 2008 12:10 am Frans Pop wrote:
> On Friday 02 May 2008, Jesse Barnes wrote:
> > This is just a transient issue during VT switch or server exit though,
> > right? X functionality isn't affected, and your VTs work fine?
>
> Transient only. I've just tested again and this time the band
> was visible on top of the text on VT1 for about 2 seconds. Then it
> disappeared.
> The artifacts also appear when I log out from KDE (i.e. without exiting the
> server), and I also get the messages when logging out and logging in again.
>
> I do not see any performance issues, but I've only used this kernel for a
> very short time.
>
> > If so, it might not be a PAT issue but just a different memory layout or
> > something (and therefore it would really just be a cosmetic bug in the X
> > driver).
>
> The artifacts may not be a PAT issue directly, but it is a clear regression
> for me as I currently have a nice clean screen when X shuts down. I'm also
> 100% sure that it is caused by enabling PAT. A kernel with same config and
> only PAT disabled does not show the artifacts.
>
> Would you like me to file a bug against X for these artifacts?
> If so, against what component? The i810 driver or the server?

I suspect an i810 driver bug is being uncovered here, since we do have 
transient VT switch corruption on some other platforms (we're just exposing 
our chip reprogramming on the screen, rather than keeping it off the whole 
time).  But there could also be something PAT specific going on, I'll have to 
walk through those code paths...

> Also attached a dmesg that shows the messages. As you can see there are
> some repeats.
> - first 22 "expected mapping type" when X is started
> - second 22 "expected mapping type" when logging in
> - 9 "freeing invalid memtype" when logging out
> - 22 "expected mapping type" when logging in again
> - 9 "freeing invalid memtype" when logging out again
> - last series "expected mapping type" when restarting X server
>
> I must say that I'm fairly disappointed by your (plural) attitude to these
> regressions, especially given that you both seem to feel it is important
> that people will actually use PAT.

Oh the messages should be removed or somehow minimized, I agree.  I'm just not 
sure if the other bug is serious enough to block PAT by default yet, but 
either way we should fix the bugs!

> That said, I'll be happy to help trace and get these issues fixed.

Thanks for your help so far...

Jesse
