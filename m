Return-Path: <linux-kernel-owner+w=401wt.eu-S1761245AbYBGOdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761245AbYBGOdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbYBGOcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:32:54 -0500
Received: from styx.suse.cz ([82.119.242.94]:55819 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754469AbYBGOcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:32:53 -0500
Date: Thu, 7 Feb 2008 15:32:47 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: remount-ro & umount & quota interaction
Message-ID: <20080207143247.GG6140@duck.suse.cz>
References: <47A9F495.8060400@msgid.tls.msk.ru> <20080207102815.GB26403@atrey.karlin.mff.cuni.cz> <47AAE250.8040702@msgid.tls.msk.ru> <20080207140441.GF6140@duck.suse.cz> <Pine.LNX.4.64.0802071508110.25157@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802071508110.25157@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 07-02-08 15:10:18, Jan Engelhardt wrote:
> 
> On Feb 7 2008 15:04, Jan Kara wrote:
> >On Thu 07-02-08 13:49:52, Michael Tokarev wrote:
> >> Jan Kara wrote:
> >> [deadlock after remount-ro followed with umount when
> >>  quota is enabled]
> >> 
> >> Hmm.  While that will prevent the lockup, maybe it's better to
> >> perform an equivalent of quotaoff on mount-ro instead? [...]
> >
> >  We couldn't leave quota on when filesystem is remounted ro because we
> >need to modify quotafile when quota is being turned off. We could turn off
> >quotas when remounting read-only. As we turn them off during umount, it
> >probably makes sence to turn them off on remount-ro as well.
> 
> Objection. XFS handles quotas differently that does not involve
> modifying a file on the fs, so quotas could stay on (even if it does
> not make much sense) while the fs is ro.
  Yes, but XFS doesn't give a damn about what we do in VFS with quotas ;)
So we are speaking here only about quotas implemented in VFS and these need
writing. BTW: When filesystem is remounted read-only, quota information
shouldn't change so it doesn't matter whether you turn it off or leave it
on. The only difference is that when you later remount rw, you have to turn
quotas on again.

> (Hm, storing quota as files reminds me of the ugly xattr hack in
> reiserfs3.)
  Oh yes... there are some similarities ;). But quota was first! ;)

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
