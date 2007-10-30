Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbXJ3TOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbXJ3TOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbXJ3TOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:14:30 -0400
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:27708 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757215AbXJ3TO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:14:28 -0400
X-YMail-OSG: xiEKp40VM1krmH6A_Pq7Ii3fv2_qRjTfR_W93tm3HJHOLWPHZFVxQCXCsnIJfpoguAnrncvPGA--
X-RocketYMMF: rancidfat
Date: Tue, 30 Oct 2007 12:14:27 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
To: Jan Engelhardt <jengelh@computergmbh.de>, Peter Dolding <oiaohm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0710301136560.31325@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <281517.30826.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> (please do not drop Cc, or I would have lost this thread part if I had 
> not been on lkml. And sometimes I am not because of the volume. Thanks.)
> 
> On Oct 30 2007 15:13, Peter Dolding wrote:
> >On 10/30/07, Crispin Cowan <crispin@crispincowan.com> wrote:
> >
> >>     * I have no clue what family to put MultiADM or Dazuko into
> >
> >MultiADMIN falls under o my god head ache.  This is more a posix
> >standard feature altered ie 1 root user turned into many.  This really
> >risks breaking the other models as a LSM.
> 
> I disagree.
> 
> Traditionally, Linux has given a process all capabilities when the
> UID changed to 0 (either by setuid(2) or executing a SUID binary).
> This has been relieved over the years, and right now with LSMs in the
> field, it is possible to 'deactivate' this special case for UID 0.
> 
> SELinux does not have this special case for UID 0. Neither does it
> seem to use capabilities (quick grep through the source). So
> basically, all users are the same, and no one has capabilities by
> default. Does SELinux thus break with other LSMs?
> 
> Now assume a SELinux system where all users have all capabilities
> (and the policy that is in place restricts the use of these
> capabilities then) -- should not be that unlikely. Does that break
> with other LSMs?

As some of the early Smack discussions brought out, some LSMs
including Smack will be perfectly happy with the traditional
Linux privilege mechanisms (choice of root and/or capablities)
while others including SELinux will go their own ways. So long
as LSMs are self contained and strictly restrictive the
mechanisms they use to modulate their behavior shouldn't be an
issue. If SELinux chooses to turn its MLS controls off between
midnight and 3am I can't see how that would be Smack's business,
even if they were somehow stacked. Multiple LSMs has issues,
like what should security_secid_to_secctx() return to the audit
system, but privilege model shouldn't be one of them.


Casey Schaufler
casey@schaufler-ca.com
