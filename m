Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYLFGQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYLFGQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 01:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbYLFGQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 01:16:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56464 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYLFGQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 01:16:46 -0500
Date: Sat, 6 Dec 2008 06:16:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, serue@us.ibm.com,
       jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp
Subject: Re: [PATCH (mmotm-2008-12-02-17-08)] Introduce
	security_path_set/clear() hooks.
Message-ID: <20081206061642.GM28946@ZenIV.linux.org.uk>
References: <200812021939.FFC05200.OVQJSOMtFFHLFO@I-love.SAKURA.ne.jp> <1228225719.26101.52.camel@moss-spartans.epoch.ncsc.mil> <49364808.1070907@nttdata.co.jp> <493649C5.2060402@nttdata.co.jp> <1228313605.32059.23.camel@moss-spartans.epoch.ncsc.mil> <200812042100.HFE00081.tFFOHMQVOLFOSJ@I-love.SAKURA.ne.jp> <1228513998.21715.75.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228513998.21715.75.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 04:53:18PM -0500, Stephen Smalley wrote:
> > Right. Locations of inserting security_path_set()/security_path_clear() pairs
> > are subset of mnt_want_write()/mnt_drop_write() pairs. Thus, we can insert
> > security_path_set()/security_path_clear() pairs into
> > mnt_want_write()/mnt_drop_write() pairs, if we can tolerate performance
> > regression. According to our rough measurement, there is about 8 - 22% of
> > performance regression. But this approach needs minimum modification to the
> > existing kernel (only two hooks to be inserted).
> 
> I assume you also need separate hooks to cover the read-only open case?
> As for your performance, your implementation of mp_* is clearly
> non-optimal, so I'd expect there is plenty of room for improvement
> there.

And just what will happen if you end up with foo_mkdir() calling something
that does e.g. pathname resolution in fs-controlled private namespace and
creates/removes some files there?
