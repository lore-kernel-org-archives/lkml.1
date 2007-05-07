Return-Path: <linux-kernel-owner+w=401wt.eu-S966148AbXEGSQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966148AbXEGSQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966092AbXEGSQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:16:03 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:64800 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966055AbXEGSQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:16:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r8cW/P7cNMuTMy0ow0nQS+aMsEyFlJ9RFiaGmEc0Uj3wOBiZg4AcSDc+ftrzo+7Yv8mG+kQjacKh3W3+T6NQ/OgsLDRcN/URkQoLkPUEBZDnmzLrSwPeIAxl2Qg8imXUwiejd89iF+H5iR9yog0tLTicQP6LVeh0Y+PEwt0Qfkc=
Message-ID: <a781481a0705071115v5bce9382q166b9c0e0c52c6ef@mail.gmail.com>
Date: Mon, 7 May 2007 23:45:58 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [PATCH 1/3] WAN Kconfig: change "depends on HDLC" to "select"
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>, "Jeff Garzik" <jeff@garzik.org>,
       "Russell King" <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <Pine.LNX.4.64.0705071901020.1479@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m3abwhcy74.fsf@maximus.localdomain>
	 <Pine.LNX.4.64.0705070343330.2733@scrub.home>
	 <m3tzupc6wz.fsf@maximus.localdomain>
	 <Pine.LNX.4.64.0705071318150.1479@scrub.home>
	 <m3r6psc0ee.fsf@maximus.localdomain>
	 <Pine.LNX.4.64.0705071509290.1479@scrub.home>
	 <463F27CE.2040008@garzik.org>
	 <Pine.LNX.4.64.0705071538060.1479@scrub.home>
	 <m3lkg0a88y.fsf@maximus.localdomain>
	 <Pine.LNX.4.64.0705071901020.1479@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> Hi,
>
> On Mon, 7 May 2007, Krzysztof Halasa wrote:
>
> > Roman Zippel <zippel@linux-m68k.org> writes:
> >
> > > HDLC doesn't really look like simple library code, what's up with all the
> > > HDLC_* options?
> >
> > Sub-modules.
>
> So it's not simple library code, or is it?
>
> > Anyway, what does the patch "screw" exactly?
>
> Normal dependencies, you basically have to manually make sure they are
> correct (and it seems with your patch they aren't). Again, _please_ (with
> sugar on top) don't use select unless you have a good reason for it.

Yes, mixing select and depends is a recipe for build disasters. Call
me a rabid fanatic, but I would in fact go as far as to say that this
whole "select" thing in the Kconfig process is one big BUG, and not a
feature. People are lazy by nature and would rather just "select" a
dependency for their config option than burden users with several
"depends".

The following rant doesn't apply only to the select above, but
unfortunately, that's precisely what happens when such stuff is
introduced ... they seem like a good idea to the introducer for his
special / rarest-of-rare case, but then others tend to {ab-,mis-}use
it and the use of such primitives soon proliferates even to cases
where they are clearly inapplicable / avoidable.
