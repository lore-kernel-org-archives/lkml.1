Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbYF0OVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbYF0OVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbYF0OVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:21:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:58687 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbYF0OVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:21:45 -0400
Date: Fri, 27 Jun 2008 16:22:23 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation
 automatically
Message-ID: <20080627162223.2df5a8b9@halley.suse.de>
In-Reply-To: <20080627141910.GD5801@redhat.com>
References: <1214510048-21215-1-git-send-email-bwalle@suse.de>
	<20080627133256.GB5801@redhat.com>
	<20080627134212.GC5801@redhat.com>
	<20080627160656.06f71661@halley.suse.de>
	<20080627141910.GD5801@redhat.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal [2008-06-27 10:19]:
> On Fri, Jun 27, 2008 at 04:06:56PM +0200, Bernhard Walle wrote:
> > * Vivek Goyal [2008-06-27 09:42]:
> > > 
> > > Thinking more about. Let me step back. I think it is not good idea to
> > > take this kernel take decision about the capability of kernel being
> > > loaded. There is no way we can find out now that if a kernel is capable
> > > of running from this memory location or not. This is highly variable. So,
> > > please ignore above comment.
> > 
> > Maybe below 4G makes sense. Because you need some 32 bit memory for DMA.
> > That's mostly an architecture limitation, so that could make sense to
> > check here.
> 
> Even if you need some 32bit memory in the lower regions, kexec can handle
> it with backup segment mechanism (currently 640K). We can always increse
> the backup region size.
> 
> So I would think that it is best to leave it without any checking and 
> then let kexec-tools handle it.

Ah, that's true. Only on x86, right? (That would be an alternative for
ia64, too ...)

But in general policy should go in userspace (if possible), so I agree
with you that kexec-tools can handle that.


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
