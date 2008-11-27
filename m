Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYK0RCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYK0RCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYK0RCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 12:02:21 -0500
Received: from outbound-mail-10.bluehost.com ([69.89.17.210]:35739 "HELO
	outbound-mail-10.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751446AbYK0RCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 12:02:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=YHdu50pdCQjRtV8qk/uCdKF76txiGxibGQ4s/UInagsG5ductDymECbeyyfgGwlZhI8o6CQB4qXhid4bYxwuRZ0PIWlXlI1Nj4XXGSiMYsPSyjHYp7La6k9vm4tMTMpf;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: oops/warning report for the week of November 26, 2008
Date: Thu, 27 Nov 2008 09:02:12 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Arjan van de Ven <arjan@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <492DD792.6080302@linux.intel.com> <20081127115236.GE29013@elte.hu>
In-Reply-To: <20081127115236.GE29013@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811270902.18020.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 27, 2008 3:52 am Ingo Molnar wrote:
> * Arjan van de Ven <arjan@linux.intel.com> wrote:
> > Rank 8: mtrr_trim_uncached_memory (warning)
> > 	Reported 227 times (619 total reports)
> > 	There is a high number of machines where our MTRR checks
> > 	trigger. I suspect we are too picky in accepting the MTRR
> > 	configuration.
>
> the warning here means: "the BIOS messed up but we fixed it up for
> you just fine".
>
> Should we print a DMI descriptor so that it can be tracked back to the
> bad BIOSen in question? Or should we (partially) silence the warning
> itself? Those BIOS bugs need fixing really: older kernels will boot up
> with bad MTRR settings - resulting in a super-slow system or other
> weirdnesses. We can tone down the message so that it doesnt show up in
> kerneloops.org. It's up to you.

I actually think we're doing something wrong here, since so many platforms 
have this behavior.  It's likely that there's an undocumented, additional 
check needed to determine whether a slot is hot pluggable.  Matthew Garrett 
recently posted a patch to check for ACPI _RMV methods, which should be an 
improvement.  I'll be putting that into linux-next soon for testing.

-- 
Jesse Barnes, Intel Open Source Technology Center

