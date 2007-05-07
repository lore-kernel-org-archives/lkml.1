Return-Path: <linux-kernel-owner+w=401wt.eu-S966829AbXEGUt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966829AbXEGUt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966818AbXEGUt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:49:56 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:5716 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966581AbXEGUty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:49:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oG4dITAIqeKhmd9cGhRkeZZ6B8m5lZg5bLgStcUrCpAwA6SSq1s0krIWrP5MdENzYpZN1Zd9ugm4hJilCc9vA9Vfqa54enBT8T45RxchQYGbwSGl6umOiSWhgd6XU8qb1AXs9HZq9d18x9dRba+uc7uGQA5/kcGQbEQ+eO2KBXM=
Message-ID: <a781481a0705071349v145787cdgf4853cb40c73fbea@mail.gmail.com>
Date: Tue, 8 May 2007 02:19:53 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH 1/3] WAN Kconfig: change "depends on HDLC" to "select"
Cc: "Roman Zippel" <zippel@linux-m68k.org>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Russell King" <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <463F8CB4.3040603@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m3abwhcy74.fsf@maximus.localdomain>
	 <Pine.LNX.4.64.0705071318150.1479@scrub.home>
	 <m3r6psc0ee.fsf@maximus.localdomain>
	 <Pine.LNX.4.64.0705071509290.1479@scrub.home>
	 <463F27CE.2040008@garzik.org>
	 <Pine.LNX.4.64.0705071538060.1479@scrub.home>
	 <m3lkg0a88y.fsf@maximus.localdomain>
	 <Pine.LNX.4.64.0705071901020.1479@scrub.home>
	 <a781481a0705071115v5bce9382q166b9c0e0c52c6ef@mail.gmail.com>
	 <463F8CB4.3040603@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Jeff Garzik <jeff@garzik.org> wrote:
> Satyam Sharma wrote:
> > Yes, mixing select and depends is a recipe for build disasters. Call
> > me a rabid fanatic, but I would in fact go as far as to say that this
> > whole "select" thing in the Kconfig process is one big BUG, and not a
> > feature. People are lazy by nature and would rather just "select" a
> > dependency for their config option than burden users with several
> > "depends".
>
> Tough, the kernel community has voted against you.

Heh ... I guess I appeared a trifle _too_ fanatic there, but I'm not.
That rant against it was actually more about controlling its
{ab-,mis-}use and rampant proliferation (even to cases where it is
inapplicable / avoidable) than removing it altogether. Especially,
when a developer is lazy / wrong and mixes select and depends in the
same dependency chain leading to errors.

> It makes far more sense to include a driver during kernel configuration,
> and have that driver pull in its libraries via 'select'.  The lame
> alternative requires developers to know which libraries they need BEFORE
> picking their drivers, which is backwards and requires legwork on the
> part of the kernel developer.

(That bit about a developer _knowing_ which libraries to select
manually before selecting a driver is not really true, you can "?" on
a config item and get all its "depends" and "select" dependencies
anyway -- and it requires more leg work, yes, but then you'll never
have build failures either)

Still, I don't really disagree w.r.t. "select"ing libraries, as long
as we're careful to limit them to _only_ libraries.
