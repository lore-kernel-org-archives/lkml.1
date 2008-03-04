Return-Path: <linux-kernel-owner+w=401wt.eu-S1763212AbYCDSNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763212AbYCDSNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYCDSNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:13:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027AbYCDSNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:13:33 -0500
Date: Tue, 4 Mar 2008 10:12:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH BUGFIX -rc3] Smack: Don't register smackfs if we're not
 loaded
In-Reply-To: <521493.30745.qm@web36606.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.1.00.0803041009210.12253@woody.linux-foundation.org>
References: <521493.30745.qm@web36606.mail.mud.yahoo.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Mar 2008, Casey Schaufler wrote:
> 
> One solution would be to tighten the smackfs code so that it
> handles the uninitialized LSM case properly.

I really would tend to prefer that.

We had a very similar situation in the ACPI/WMI code, where some WMI 
helper routines would crash just because the WMI data structures hadn't 
been initialized.

The proper fix in that case (in my opinion, and the one that thus got 
committed ;^) was simply to make sure that the data structures were simply 
always consistent (and empty), even if the code itself was disabled. That 
just automatically meant that it didn't need any global flags to be 
tested.

So _if_ the alternative is as simple as just making sure that smackfs 
keeps its data structures consistent even when disabled, I think that's 
the right patch, rather than adding a separate hack to not touch them.

		Linus
