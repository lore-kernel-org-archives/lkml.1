Return-Path: <linux-kernel-owner+w=401wt.eu-S935081AbZLGNom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935081AbZLGNom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934963AbZLGNol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:44:41 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:34010 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934786AbZLGNok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:44:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iLE2N2auwQShsupnTZlSlt1xa5H8AyqTz08SA+8QZjh4j+W0e3OaBhgSBJ5jr/XDK3
         EJCNliQ+Wu5vX27j+rNBO1S3/AB57JKJInb2GxgCUnhTuDxpBaRFV5t9MSdzyC/dFmj8
         79K7p6ETjD3lIPEc876dhPPD5Lp+yKCdlDdpU=
MIME-Version: 1.0
In-Reply-To: <c1f41c620912061952k4945a7c8j4567ab17424e4d91@mail.gmail.com>
References: <4B1A6F78.8010408@myrealbox.com>
	 <50CA8D92EC%linux@youmustbejoking.demon.co.uk>
	 <20091206173222.4c2d5aaa@jbarnes-piketon>
	 <c1f41c620912061952k4945a7c8j4567ab17424e4d91@mail.gmail.com>
Date: Mon, 7 Dec 2009 20:38:39 +0700
Message-ID: <c1f41c620912070538y4f865cechf21d2802ab237510@mail.gmail.com>
Subject: Re: 2.6.31 -> 2.6.32 Sound and video regressions
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Darren Salt <linux@youmustbejoking.demon.co.uk>,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       luto@myrealbox.com, eric@anholt.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 7, 2009 at 10:52 AM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
> On Mon, Dec 7, 2009 at 8:32 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> On Sat, 05 Dec 2009 23:44:55 +0000
>> Darren Salt <linux@youmustbejoking.demon.co.uk> wrote:
>>
>>> I demand that Andy Lutomirski may or may not have written...
>>>
>>> > Emmanuel Benisty wrote:
>>> [snip]
>>> >> I just wanted to report 2 regressions I am having now with 2.6.32.
>>> >> Video
>>> >> Screen is flickering/glitching like crazy in X. It happens whether
>>> >> randomly or when conky is refreshed, when the mouse cursor moves
>>> >> and like hell when a page is loading in the browser. Not so easy to
>>> >> describe this issue.
>>> [snip]
>>>
>>> > That sounds like FIFO underruns, which (I think) were introduced
>>> > when self-refresh was enabled but should have been fixed. I
>>> > personally have no clue how to fix them, but if you told the Intel
>>> > people what kind of chip you have (lspci output), they can probably
>>> > fix it.
>>>
>>> It also sounds like what I'm seeing on my EeePC 901. It only happens
>>> after resume, which makes STR a little less than useful; the display
>>> will, sooner or later, show a single colour (which is, presumably,
>>> the result of a display engine hang, as described in the comment
>>> immediately before intel_calculate_wm) and, seemingly, be stuck like
>>> that until power-off or reboot.
>>>
>>> Whether it *is* the same problem, I couldn't say.
>>>
>>> Needless to say, this problem goes away if I disable KMS.
>>
>> Arg, there are a few reports of this now, but I haven't been able to
>> reproduce it.  I'll try harder...  (FYI the upstream
>> bugs.freedesktop.org # for it is 24314).
>
> It *seems* that we are facing two different issues here (I don't even
> use S2R and the problem is there since the very first second I start
> X). Anyway, I have bisected the problem on my box, it turns out to be
> this one:
>
> drm/i915: Fix render reclock availability detection
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=181a5336d6cc836f05507410d66988c483ad0154
>
So, I have reverted this commit and rebuilt 2.6.32. It completely
solved the issue described in my first post.
