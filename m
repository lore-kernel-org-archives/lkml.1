Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311Ab0AIVcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab0AIVcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 16:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079Ab0AIVcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 16:32:32 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:59536 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab0AIVcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 16:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O1+0wmzsSs9NAnl3Yn9l+tXFYe3w6quG1htzgoelK3DSogyhGVRR2XwhBuz3CuNjaf
         1aPacGdyWK9gsvpnNN1F1/+KGu0oJFEdP7vdgruzS/1YT+UZQ3mu5wZ8tZN7ZXXOGBYy
         +sHmw4rxEcmclEjTk8WFGxiDw3B4Xh44aqxno=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001091012080.7821@localhost.localdomain>
References: <201001090045.33784.rjw@sisk.pl>
	 <alpine.LFD.2.00.1001081548320.7821@localhost.localdomain>
	 <alpine.DEB.2.00.1001090214220.21286@skynet.skynet.ie>
	 <20100108185041.7aae6c01@jbarnes-piketon>
	 <20100109120141.GA4319@localhost.localdomain>
	 <alpine.LFD.2.00.1001091012080.7821@localhost.localdomain>
Date: Sun, 10 Jan 2010 07:32:30 +1000
Message-ID: <21d7e9971001091332v23ac0e28m1b1890cd667aacb8@mail.gmail.com>
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o 
	KMS
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jerome Glisse <glisse@freedesktop.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 4:17 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 9 Jan 2010, Jerome Glisse wrote:
>
>> On Fri, Jan 08, 2010 at 06:50:41PM -0800, Jesse Barnes wrote:
>> >
>> > Linus, can we ever drop those old paths?  Maybe after the new bits have
>> > been around for awhile?  Users of really old userspace stacks would
>> > lose 3D support, but they'd still have 2D, so it wouldn't be a complete
>> > break.  The non-KMS paths sometimes break like this anyway without us
>> > noticing (especially some of the weirder 3D paths)...
>> >
>> > Just thinking out loud, we could really kill a lot of really bad code...
>>
>> I among those who would love such things to happen :)
>
> I don't want to drop it _yet_, but "ever"? Sure. When people are sure that
> KMS actually handles all the cases that old X does (maybe that's true
> now), and we've had more than just a couple of kernel releases of _stable_
> Intel KMS, I suspect we can start thinking about "ok, nobody seriously
> uses 3D on Intel integrated graphics _and_ updates the kernel".
>
> The fact that they'd still have a working X setup would make it generally
> much more palatable, I think.
>
> But we definitely need more than just a couple of kernel releases. So
> we're talking timescales of "more than a year of stable code". Whether
> that is "six months from now" or "two years from now", I can't judge.
>
> And people can try to convince me to be more or less aggressive about it,
> so take the above as a more of a personal opinion that is open to
> change than anything definite and final.

I'm in the 2-3 years at a minimum, with at least one kernel with no serious
regressions in Intel KMS, which we haven't gotten close to yet. I'm not even
sure the Intel guys are taking stable seriously enough yet. So far I don't think
there is one kernel release (even stable) that works on all Intel
chipsets without
backporting patches. 2.6.32 needs the changes to remove the messed up
render clock hacks which should really have been reverted a lot earlier since
we had a lot of regression reports. The number of users using powersave=0
to get anything approaching useable is growing etc.

We do have ppl who run latest kernels on RHEL5 userspace and I'd rather
not have that break badly, I'm guessing more than 3D will break if we remove
this, since we need the DRM to allocate memory for 2D stuff, and will probably
find the fallback to AGP is broken. Again Intel ppl would have to do a lot
of testing on the fallback before removing anything, which is time I don't see
anyone willing to spend.

Dave.
Dave.
