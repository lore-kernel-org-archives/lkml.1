Return-Path: <linux-kernel-owner+w=401wt.eu-S935926AbYCFU41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935926AbYCFU41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935774AbYCFUyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:54:43 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:41545 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935285AbYCFUyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:54:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wlhQIXXfH3VDxq2xoCzdei2gl90UTnvnps+X5jLZZ5kktfqRF8y2nO0+tUPHj4zvb034u3l4S4AtsnygM2GWgdgkhoc8zoVEZ8kcDfJet7hTwy8jp40FyBfZxleZrWpSPe5eqL4FGNd99mEYurjZAnmECAAvtjgd1LVDI9oVlz8=
Message-ID: <84fc9c000803061254i5865f68ev11fcfd08b698c58f@mail.gmail.com>
Date: Thu, 6 Mar 2008 21:54:38 +0100
From: "Richard Guenther" <richard.guenther@gmail.com>
To: "Joe Buck" <Joe.Buck@synopsys.com>
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Cc: "Andi Kleen" <andi@firstfloor.org>, "Andrew Haley" <aph@redhat.com>,
       "Aurelien Jarno" <aurelien@aurel32.net>,
       "H. Peter Anvin" <hpa@zytor.com>, "Michael Matz" <matz@suse.de>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
In-Reply-To: <20080306173438.GH17267@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080305153020.GA24631@volta.aurel32.net>
	 <20080305195834.GA17267@synopsys.com>
	 <20080305202319.GA17053@volta.aurel32.net>
	 <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
	 <47CF0627.2070200@zytor.com> <47CF07FE.10200@aurel32.net>
	 <47CFBF28.4060309@redhat.com> <871w6ogjnu.fsf@basil.nowhere.org>
	 <84fc9c000803060406u7dfa0d38ve8af3154bf5064f9@mail.gmail.com>
	 <20080306173438.GH17267@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2008 at 6:34 PM, Joe Buck <Joe.Buck@synopsys.com> wrote:
>
> On Thu, Mar 06, 2008 at 01:06:17PM +0100, Richard Guenther wrote:
>  > On 06 Mar 2008 12:45:57 +0100, Andi Kleen <andi@firstfloor.org> wrote:
>  > > Andrew Haley <aph@redhat.com> writes:
>  > >  >
>  > >  > I suppose one could apply the precautionary principle, but those systems that
>  > >  > don't update kernels won't update gcc either, so the solution won't work.
>  > >
>  > >  You seem to assume that running a gcc 4.3 compiled binary requires a
>  > >  gcc update. That is not necessarily true.
>  >
>  > It (sometimes) requires a libgcc and libstdc++ update.
>
>  "Sometimes" is correct; many users commonly run newer compilers on older
>  distros, with LD_LIBRARY_PATH set to pick up the correct C++ support
>  library.  This is particularly common on servers, where you don't want to
>  mess with a working system but you might need to run newer code.
>
>  So, we've been arguing for a while, so the question is what to do.
>
>  Using a principle based on the old IETF concept of being liberal in what
>  you accept, and conservative in what you send, I think that both the Linux
>  kernel and gcc should fix the problem.  The kernel should fix the
>  information leak, and gcc should remove the assumption that the direction
>  flag is set in a given direction on function entry.
>
>  The gcc patch will be too late for 4.3.0, but it would be on the 4.3
>  branch, and we would recommend that distros pick it up for any compilers
>  they ship.

A patched GCC IMHO makes only sense if it is always-on, yet another option
won't help in corner cases.  And corner cases is exactly what people seem
to care about.  For this reason that we have this single release, 4.3.0, that
behaves "bad" is already a problem.

Richard.
