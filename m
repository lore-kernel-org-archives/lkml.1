Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZJ0Iei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZJ0Iei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbZJ0Ieh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:34:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51839 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbZJ0Ief (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:34:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AE6B094.90505@s5r6.in-berlin.de>
Date: Tue, 27 Oct 2009 09:34:28 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: david@lang.hm
CC: Greg KH <gregkh@suse.de>, "John W. Linville" <linville@tuxdriver.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] strip: move driver to staging
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com> <20091023161006.GA1580@ucw.cz> <20091026165518.GE2792@tuxdriver.com> <alpine.DEB.2.00.0910261013430.11504@asgard.lang.hm> <20091026184734.GA21591@suse.de> <alpine.DEB.2.00.0910262106050.14994@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.0910262106050.14994@asgard.lang.hm>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Mon, 26 Oct 2009, Greg KH wrote:
>> A person "claiming maintainership" would then be responsible for keeping
>> the API up to date and ensuring that the driver worked.  To do that,
>> hardware would probably need to be present.
> 
> actually, I understood that the person changing the API was responsible
> for making the changes. when did this change?

I'm not sure what the procedure with drivers/staging/ is, which is a
middle ground between in-tree and out-of-tree.  For in-tree code, last
time I watched the procedure was thus:
  - Those who change an infrastructure are responsible to /code/ the
necessary changes in all infrastructure using subsystems.
  - Usually they are also responsible to submit those changes upstream;
if the change is done in a source-compatible manner during a transition
period, then those API changes in dependent subsystems are sometimes
submitted via the respective subsystem maintainers instead, but that's
not typical.
  - Those who introduce such changes usually cannot be expected to
runtime-test except with one or few subsystems for which they happen to
have matching hardware.  Thus, a small but real danger of regressions
remains.  Usually only the subsystem maintainer or users can detect and
fix such regressions.

But remember, there are no formal rules, there are only "best
practices".  (And sometimes new procedures are tried out in order to
find out whether they work or not, such as the 2.4+2.5 -> 2.6 switch of
development models, the merge window, linux-next, drivers/staging/ as a
way in for out-of-tree drivers, drivers/staging as a way out for broken
or obsolete drivers...)
-- 
Stefan Richter
-=====-==--= =-=- ==-==
http://arcgraph.de/sr/
