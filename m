Return-Path: <linux-kernel-owner+w=401wt.eu-S1764626AbXJRC7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764626AbXJRC7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 22:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760746AbXJRC71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:59:27 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:33502 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760869AbXJRC7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:59:25 -0400
X-YMail-OSG: 6yWZ74IVM1lWi3Cj8JQiz._ylYZiW4bbO2k23s9KV3Pfaqt_wAjWFEUYoc2xF3TabQJq.zKevw--
Date: Wed, 17 Oct 2007 21:59:20 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, sds@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, morgan@kernel.org,
       chrisw@sous-sol.org, linux-kernel@vger.kernel.org, kaigai@kaigai.gr.jp,
       casey@schaufler-ca.com
Subject: Re: [RFC] [PATCH 2/2] capabilities: implement 64-bit capabilities
Message-ID: <20071018025920.GA5067@vino.hallyn.com>
References: <20071016022730.GA8925@sergelap.austin.ibm.com> <20071016023100.GA10698@sergelap.austin.ibm.com> <1192544299.8702.78.camel@moss-spartans.epoch.ncsc.mil> <20071016214159.GB13294@sergelap.austin.ibm.com> <20071017180002.33fe4986.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017180002.33fe4986.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Tue, 16 Oct 2007 16:41:59 -0500
> "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > To properly test this the libcap code will need to be updated first,
> > which I'm looking at now...
> 
> This seems fairly significant.  I asusme that this patch won't break
> presently-deployed libcap?

It will break libcap.  And I'm not sure of the right way to address it.
So I was hoping to hear some ideas from Andrew Morgan, Chris Wright, and
Kaigai.

We can introduce new capget64() and capset64() calls, and have
capget() return -EINVAL or -EAGAIN if a high bit would be needed to
accurately get the task's capabilities.

Or we can require a new libcap, since capget and capset aren't
required for most day-to-day function anyway.

I guess now that I've written this out, it seems pretty clear
that capget64() and capget64() are the way to go.  Any objections?

thanks,
-serge
