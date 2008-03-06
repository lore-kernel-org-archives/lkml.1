Return-Path: <linux-kernel-owner+w=401wt.eu-S934252AbYCFRfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252AbYCFRfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbYCFRes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:34:48 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:33554 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166AbYCFRer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:34:47 -0500
Date: Thu, 6 Mar 2008 09:34:38 -0800
From: Joe Buck <Joe.Buck@synopsys.COM>
To: Richard Guenther <richard.guenther@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andrew Haley <aph@redhat.com>,
       Aurelien Jarno <aurelien@aurel32.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Michael Matz <matz@suse.de>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Message-ID: <20080306173438.GH17267@synopsys.com>
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <47CF0627.2070200@zytor.com> <47CF07FE.10200@aurel32.net> <47CFBF28.4060309@redhat.com> <871w6ogjnu.fsf@basil.nowhere.org> <84fc9c000803060406u7dfa0d38ve8af3154bf5064f9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84fc9c000803060406u7dfa0d38ve8af3154bf5064f9@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 01:06:17PM +0100, Richard Guenther wrote:
> On 06 Mar 2008 12:45:57 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> > Andrew Haley <aph@redhat.com> writes:
> >  >
> >  > I suppose one could apply the precautionary principle, but those systems that
> >  > don't update kernels won't update gcc either, so the solution won't work.
> >
> >  You seem to assume that running a gcc 4.3 compiled binary requires a
> >  gcc update. That is not necessarily true.
> 
> It (sometimes) requires a libgcc and libstdc++ update.

"Sometimes" is correct; many users commonly run newer compilers on older
distros, with LD_LIBRARY_PATH set to pick up the correct C++ support
library.  This is particularly common on servers, where you don't want to
mess with a working system but you might need to run newer code.

So, we've been arguing for a while, so the question is what to do.

Using a principle based on the old IETF concept of being liberal in what
you accept, and conservative in what you send, I think that both the Linux
kernel and gcc should fix the problem.  The kernel should fix the
information leak, and gcc should remove the assumption that the direction
flag is set in a given direction on function entry.

The gcc patch will be too late for 4.3.0, but it would be on the 4.3
branch, and we would recommend that distros pick it up for any compilers
they ship.

