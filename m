Return-Path: <linux-kernel-owner+w=401wt.eu-S934569AbYEBOPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934569AbYEBOPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758866AbYEBOPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:15:36 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:56521 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279AbYEBOPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:15:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OJ90Cd/+QwRkkZwHaNBgOPdvuG4M28z2LwFaKw2YWFSUzHsd+yIbYjseJtL7WIRzHFbOmIIk1bhngE282moKE1dfMf8JveD/GctOTdwSWl1PiD6ZcvHPK5LgWjautyp+/L1rDs3wPzT3ssqACxjtYxyD0pIdl6rMbFh2Hk0fIpA=
Message-ID: <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com>
Date: Fri, 2 May 2008 07:15:32 -0700
From: "Jeff Schroeder" <jeffschroed@gmail.com>
Reply-To: jeffschroeder@computer.org
To: "Chris Mason" <chris.mason@oracle.com>
Subject: Re: Btrfs v0.14 Released
Cc: "Jan Engelhardt" <jengelh@medozas.de>, "Jeff Mahoney" <jeffm@suse.com>,
       "Tim Gardner" <tim.gardner@canonical.com>,
       linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       "John Johansen" <jjohansen@suse.de>
In-Reply-To: <200805020852.51125.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804291601.32945.chris.mason@oracle.com>
	 <481A23AB.1020302@suse.com>
	 <alpine.LNX.1.10.0805020837490.6463@fbirervta.pbzchgretzou.qr>
	 <200805020852.51125.chris.mason@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 5:52 AM, Chris Mason <chris.mason@oracle.com> wrote:
> On Friday 02 May 2008, Jan Engelhardt wrote:
>  > On Thursday 2008-05-01 22:10, Jeff Mahoney wrote:
>  > >>>> Couldn't you #ifdef based on CONFIG_SECURITY_APPARMOR ? This ought to
>  > >>>> work for Hardy. However the next development kernel (Intrepid) does
>  > >>>> not have the APPARMOR patches, so just knowing that its an UBUNTU
>  > >>>> kernel is not specific enough.
>  > >>>
>  > >>> I've been assuming the apparmor patches change remove_suid even when
>  > >>> they are not enabled in the config.
>  > >>
>  > >> Lets get Kees involved. He developed the patch set for Hardy. I would
>  > >> hope that if CONFIG_SECURITY_APPARMOR=n then the source would default to
>  > >> its normal state.
>  > >
>  > >remove_suid() isn't the only change AppArmor makes to the VFS interface.
>  > >It's pretty invasive and requires that dentries are passed with a
>  > >companion vfsmount in most cases. Putting #ifdefs around all that code
>  > >would make the problem worse, not better.
>  >
>  > An alternative approach, and IMHO better suited, is to:
>  >
>  >       make -C ${kdir} all I_HAZ_AN_APPARMOR=1
>
>  This is better than the current situation (oops without any clues), but I'd
>  prefer that people not have to know what apparmor is or if they have it.
>  (This isn't a knock on apparmor, I'd just rather take care of it
>  automagically).

Chris,

Make is not my forte, but here is a working test to see if apparmor
exists in Ubuntu 8.04.
Maybe have make apply a patch to the btrfs source if this test
succeeds? Does this work in SUSE?

http://www.digitalprognosis.com/opensource/patches/btrfs/lame_apparmor_test_for_btrfs.patch

The symlink from /lib/modules/`uname -r`/build ->
/path/to/kernel/headers/ doesn't exist on CentOS 5.
Even though it is a hack, is this or something like it usable? Or is
this the completely wrong direction?

-- 
Jeff Schroeder

Don't drink and derive, alcohol and analysis don't mix.
http://www.digitalprognosis.com
