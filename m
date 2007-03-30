Return-Path: <linux-kernel-owner+w=401wt.eu-S1750699AbXC3MbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750699AbXC3MbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 08:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbXC3MbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 08:31:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:42050 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXC3MbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 08:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bfG0lxn9LFzN+9Dty4iAb6V+0aTmclcprPvCMxz9YdX+fMDs+YqY3/pOnNqdVXVsVBPjg0p9TOZzOgxWGeQm9drCi/KhyFk57A+kPlYaQznnqLUbz5pYE4iPJKWxbk6BhoXqCFJnQfRCCOo4tzIV8avOipQHk8wg9CuHmN6FpNM=
Message-ID: <3b44d3fb0703300531l6293e792y94d4f16e43652fb5@mail.gmail.com>
Date: Fri, 30 Mar 2007 18:01:03 +0530
From: "Milind Arun Choudhary" <milindchoudhary@gmail.com>
To: "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [KJ][PATCH] BIT macro cleanup
Cc: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz
In-Reply-To: <460B3244.9060405@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070328033309.GA9597@arun.site>
	 <20070328190925.GC5306@martell.zuzino.mipt.ru>
	 <460B3244.9060405@student.ltu.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/07, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> Alexey Dobriyan wrote:
> > On Wed, Mar 28, 2007 at 09:03:09AM +0530, Milind Arun Choudhary wrote:
> >
> >> +#define BIT(nr)	(1UL << ((nr) % BITS_PER_LONG))
> >>
> >
> > I think this would be a disaster because something like
> >
> > 	BIT(123)
> >
> > would not even generate a warning.
> >
> There were a discussion on this, at KJ, when BIT was first used with a
> modular operation. I said the same thing as you do now, but a big user
> of BIT is the input-subsystem who defined their BIT as above. Also it
> was mentioned that the compiler can only find the statical errors, a
> variable input can break it in runtime.
> + if we _really_ want to check the tree for such warnings, it is easy to
> remove the modular operation temporarily (and keep away of input/)
>
> I don't say I like this, just that it is a choose between possible errors.
as discussed in earlier thread there are two kinds of users of BIT
1. input sybsystem which needs the "% BITS_PER_LONG"
2. & all other who don't, so that they are warned when the bit no overflows
I think a simple macro cant serve both the purposes

so IMHO there should be two macros
 +#define BIT(nr)	(1UL << (nr))
which server the first case

&
 +#define XXXBITXXX(nr)	(1UL << ((nr) % BITS_PER_LONG))
for input users
earlier i suggested a name BITWRAP
but some people hate it i think
'm fine with any other name as well
inputs....suggest a name

so that we can still keep these two macros (along with LLBIT) in
bitops.h & use apporpriately

only hassle is the whole input tree is to be searched & replaced for BIT
is this OK

-- 
Milind Arun Choudhary
