Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbZAFVVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbZAFVVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZAFVUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:20:51 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:15912 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZAFVUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:20:50 -0500
X-IronPort-AV: E=Sophos;i="4.37,221,1231131600"; 
   d="scan'208";a="80712877"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: debugfs & vfs file permission issue?
Date: Tue, 6 Jan 2009 16:20:54 -0500
User-Agent: KMail/1.9.5
Cc: "Greg KH" <gregkh@suse.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <200901052157.07306.rgetz@blackfin.uclinux.org> <200901061012.38888.rgetz@blackfin.uclinux.org> <8bd0f97a0901060720l40099bd6o63a692e5fdd3e098@mail.gmail.com>
In-Reply-To: <8bd0f97a0901060720l40099bd6o63a692e5fdd3e098@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901061620.54179.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 06 Jan 2009 21:20:42.0400 (UTC) FILETIME=[A15BBA00:01C97044]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 6 Jan 2009 10:20, Mike Frysinger pondered:
> On Tue, Jan 6, 2009 at 10:12, Robin Getz wrote:
> > On Tue 6 Jan 2009 07:05, Robin Getz suggested:
> >> adding a readonly, and writeonly, and ensuring that when you call
> >> debugfs_create_*, the mode is checked, and the "correct" fops are set
> >> doesn't seem like it would be a bad idea? This would enforce the
> >> kernel programmer's view on the world, and not allow pesky root users
> >> to override things....
> >>
> >> Greg - would you take something like that?
> >
> > How about this?
> >
> > Feel free to nak it - we can do the same thing where we are calling the
> > debugfs_create_* functions - this just makes it cleaner in my opinion.
> >
> > ---
> >
> > In many SOC implementations there are hardware registers can be read only,
> > or write only. This extends the debugfs to enforce the file permissions for
> > these types of registers, by providing a set of fops which are read only
> > or write only. This assumes that the kernel developer knows more about the
> > hardware than the user (even root users) - which is normally true.
> 
> we want it for cpu registers, but i dont see any reason why this
> wouldnt also apply to external devices attached via memory interfaces
> ... fifos and such ...

Yes - Although the existing use case is for SOC on chip registers - it applies
to anything where the kernel developer really doesn't want to allow the 
user to do an access that will cause a negative side effect (crash, effect
fifos, etc).

-Robin
