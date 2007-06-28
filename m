Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbXF1Nge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbXF1Nge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbXF1Ng0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:36:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48769 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbXF1NgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:36:25 -0400
Date: Thu, 28 Jun 2007 08:36:12 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morgan <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, "Serge E. Hallyn" <serge@hallyn.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       casey@schaufler-ca.com, Andrew Morton <akpm@google.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: implement-file-posix-capabilities.patch
Message-ID: <20070628133612.GA29641@sergelap.austin.ibm.com>
References: <4676007F.7060503@kernel.org> <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com> <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com> <467CD63B.4000703@kernel.org> <20070624155100.GA5167@vino.hallyn.com> <4681EED8.6050005@kernel.org> <20070627131654.GA2679@sergelap> <468352EC.2080704@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468352EC.2080704@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Serge E. Hallyn wrote:
> >> Does that explain it?
> > 
> > Yes, thanks, but then it still could come in handy to have fE be a full
> > bitset, so the application gets some eff caps automatically, while
> > others it has to manually set...
> 
> [We touched on this a number of emails back.]
> 
> If an application is capability aware, it can manipulate its own
> capabilities and should have fE=0.
> 
> If an application is not capability aware, it needs to have *all* of its
> capabilities enabled at exec() time. Otherwise, it won't work.
> 
> The only reason for having an fE bitmap is to allow a capability-aware
> program (you really trust to do its privileged operations carefully) to
> be lazy and get some of its capabilities raised for free. Perhaps you
> can clarify why this is a desirable thing? :-)

Sure - because it doesn't hurt anything, someone just *might* find it
useful one day, and mostly the three bitmaps just look a lot cleaner to
me than hiding a bit inside the version field.  There are a *few* people
using this, and so a complete switch in format for no actual net gain
seems wrong.  If we want to fake fE to the user as being one bit we can
do that through the setfcaps/getfcaps programs.

There also are prior examples of doing it this way (i.e. Olaf Dietsche's
implementation)

OTOH I don't deny implementing it fully as you describe seems to make
the intent of the code clearer to readers and maintainers.

I guess maybe I'll give it a go and see what turns out.

thanks,
-serge
