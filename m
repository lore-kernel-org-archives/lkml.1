Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYBRNpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYBRNpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:45:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYBRNor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:44:47 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:48004 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYBRNop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:44:45 -0500
Date: Mon, 18 Feb 2008 07:44:43 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, charles.kirsch@internet.lu,
       Andrew Morgan <morgan@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Gerald Combs <gerald@wireshark.org>,
       Gilbert Ramirez <gram@alumni.rice.edu>, Guy Harris <guy@alum.mit.edu>
Subject: Re: Possible problem in linux file posix capabilities
Message-ID: <20080218134443.GA22552@sergelap.austin.ibm.com>
References: <20080217224851.GA9168@sergelap.austin.ibm.com> <728865.70879.qm@web36611.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <728865.70879.qm@web36611.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Casey Schaufler (casey@schaufler-ca.com):
> 
> --- "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > ....
> > 
> > Two quick fixes for you right now (apart from the one you've already
> > got :)  would be
> > 
> > 	1. give wireshark cap_kill, by doing something like
> > 
> > 		capset cap_kill=ep /bin/wireshark
> > 
> > 	2. compile a kernel with SECURITY_FILE_CAPABILITIES=n
> > 
> > Andrew, this pretty much was bound to happen...  we need to figure out
> > what our approach here should be.  My preference is still to allow
> > signals when p->uid==current->uid so long as !SECURE_NOROOT.  Then as
> > people start using secure_noroot process trees they at least must know
> > what they're asking for.
> > 
> > An alternative stance is to accept these things as they come up and try
> > to quickly work with the authors of such programs to work around it.  I
> > suppose in a security sense that's the superior way :)  But it also
> > seems likely to lead to most people choosing option 2 above and not
> > bothering to fix the problem.
> 
> I probably just missed it when it went by, but do you have some
> test cases for file capabilities lying about that I might use?

Yup, please download the latest ltp cvs tree (I don't think it's in any
release yet, though I may be wrong) and look under
testcaes/kernel/security/filecaps.  Or just do

	cd ltp
	make && make install && ./runltp -s filecap

-serge
