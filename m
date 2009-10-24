Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZJXMwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZJXMwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 08:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZJXMwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 08:52:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58560 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZJXMwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 08:52:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AE2F853.2060604@s5r6.in-berlin.de>
Date: Sat, 24 Oct 2009 14:51:31 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091017 SeaMonkey/1.1.18
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@fluxnic.net>, "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
References: <20091020034829.GA12833@elte.hu>	 <20091020140750.GH11972@erda.amd.com>	 <alpine.LFD.2.00.0910210654480.5125@eeepc.linux-foundation.org>	 <20091022122042.e535d43c.sfr@canb.auug.org.au>	 <20091023112732.GB5886@elte.hu> <4AE19A74.1090709@garzik.org>	 <20091023123555.GA25366@elte.hu>	 <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com>	 <20091023134115.GD27097@elte.hu>	 <alpine.LFD.2.00.0910231424440.21460@xanadu.home>	 <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com>
In-Reply-To: <1256326512.26028.34.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Some of the reasons for the constant rebasing are:
> 
> 1) the patches are held in quilt, which just by nature leads to
> rebasing.  These developers find that quilt is the best tool for the
> job.

It shouldn't be difficult to implement a git-quiltimport porcelain which
  - remembers a previous import of a quilt tree,
  - compares that one ( = an existing branch) with a new quilt import
    ( = a new branch),
  - reuses all commits of the old import which have identical diffs/
    changelog/ authorship/ parent changeset as ones in the new import,
  - discards (or reverts?) commits of the old import that don't match
    the new import in this way,
  - finally rebases all remaining commits from the new import onto the
    kept old ones.

[OTOH the whole discussion is not about stable SHA1s in linux-next per
se, AFAIU, but about stability of (the history of) the code which is
released into linux-next, or about misuse of linux-next for more than
final integration-testing...?]
-- 
Stefan Richter
-=====-==--= =-=- ==---
http://arcgraph.de/sr/
