Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbYCDRpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbYCDRpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYCDRpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:45:07 -0500
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:36832 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751123AbYCDRpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:45:06 -0500
X-YMail-OSG: NOWqJxsVM1msUqW10wQtWhTZruDc.BFZ_mlENTVlAXZzKVOe2IYhBzvlvsCfK87oLcdY1ixXrw--
X-Mailer: YahooMailRC/902.35 YahooMailWebService/0.7.162
Date: Tue, 4 Mar 2008 09:45:04 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH BUGFIX -rc3] Smack: Don't register smackfs if we're not loaded
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <521493.30745.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----
> From: Linus Torvalds <torvalds@linux-foundation.org>
> To: Ahmed S. Darwish <darwish.07@gmail.com>
> Cc: Casey Schaufler <casey@schaufler-ca.com>; LKML <linux-kernel@vger.kernel.org>
> Sent: Tuesday, March 4, 2008 9:21:19 AM
> Subject: Re: [PATCH BUGFIX -rc3] Smack: Don't register smackfs if we're not loaded
> 
> 
> 
> On Tue, 4 Mar 2008, Ahmed S. Darwish wrote:
> > 
> > Smackfs initialization without an enabled Smack leads to
> > an early Oops that renders the system unusable.
> 
> I really think this is bogus. Global enables like this are just wrong, and 
> a sign that something else bad is going on.
> 
> What is the oops? Why does it happen?

A kernel that is built with both SELinux and Smack contains
all of the components for both, including smackfs. If SELinux
is chosen as the module to be used and smackfs is initialized
the oops occurs because the Smack initialization that smackfs
depends on has not been done.

One solution would be to tighten the smackfs code so that it
handles the uninitialized LSM case properly.

Another would be to set up Kconfig as to make SELinux and Smack
mutually exclusive, although I really don't know how well that
would go over in testing circles because "config all on" becomes
ambiguous.

A third would be to provide for stacking, but I assume that's
beyond the scope of this exercise.

So I think that fixing up smackfs is the right choice at this point.

> 
> 
> Linus



 
Casey Schaufler
casey@schaufler-ca.com 
