Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbYJMERj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbYJMERj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 00:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYJMERa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 00:17:30 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:58073 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYJMER3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 00:17:29 -0400
X-IronPort-AV: E=Sophos;i="4.33,400,1220241600"; 
   d="scan'208";a="61000515"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Tim Bird" <tim.bird@am.sony.com>
Subject: Re: RFC - size tool for kernel build system
Date: Mon, 13 Oct 2008 00:17:32 -0400
User-Agent: KMail/1.9.5
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "linux-embedded" <linux-embedded@vger.kernel.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
References: <48EBD268.50208@am.sony.com> <20081009152151.GB17013@cs181140183.pp.htv.fi> <48EE9A1C.8040301@am.sony.com>
In-Reply-To: <48EE9A1C.8040301@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810130017.32413.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 13 Oct 2008 04:17:27.0862 (UTC) FILETIME=[9A3FED60:01C92CEA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 9 Oct 2008 19:56, Tim Bird pondered:
> Adrian Bunk wrote:
> > The building blocks that would be useful are IMHO:
> > - a make target that generates a report for one kernel
> >   (like the checkstack or export_report targets)
> > - a script that compares two such reports and outputs the
> >   size differences
> > 
> > That's also easy to do, and if that's what's wanted I can send a patch 
> > that does it.
> 
> I took a stab at this with the attached two scripts.  These are
> not quite ready for prime time, but show the basic idea.
> I only have a partial list of subsystems, and am skipping the
> runtime data collection, for now.
> 
> I have only made the scripts, not any make targets for them.
> 
> I record all data into a flat namespace, which makes it easier to compare
> later.
> 
> > Everything else is IMHO overdesigned.
> One element of this design is the ability to configure
> the diff-size-report tool to watch only certain values, and to
> return a non-zero exit code under certain conditions.  This makes
> it possible to use the tool with git-bisect to find the source of
> a size regression. I believe Linus asked for something like this
> at the last kernel summit.
> 
> Without the use of the config file, diff-size-report is very
> to bloat-o-meter, but provides info about additional
> aggregate items (like subsystems and the full kernel).
> 
> Feedback is welcome.

This seems to still only look at the text section (only uses nm)? not data or 
other section sizes increasing?
