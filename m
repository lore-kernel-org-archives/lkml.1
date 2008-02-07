Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbYBGOK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbYBGOK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYBGOKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:10:20 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58689 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbYBGOKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:10:19 -0500
Date: Thu, 7 Feb 2008 15:10:18 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jan Kara <jack@suse.cz>
cc: Michael Tokarev <mjt@tls.msk.ru>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: remount-ro & umount & quota interaction
In-Reply-To: <20080207140441.GF6140@duck.suse.cz>
Message-ID: <Pine.LNX.4.64.0802071508110.25157@fbirervta.pbzchgretzou.qr>
References: <47A9F495.8060400@msgid.tls.msk.ru> <20080207102815.GB26403@atrey.karlin.mff.cuni.cz>
 <47AAE250.8040702@msgid.tls.msk.ru> <20080207140441.GF6140@duck.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 7 2008 15:04, Jan Kara wrote:
>On Thu 07-02-08 13:49:52, Michael Tokarev wrote:
>> Jan Kara wrote:
>> [deadlock after remount-ro followed with umount when
>>  quota is enabled]
>> 
>> Hmm.  While that will prevent the lockup, maybe it's better to
>> perform an equivalent of quotaoff on mount-ro instead? [...]
>
>  We couldn't leave quota on when filesystem is remounted ro because we
>need to modify quotafile when quota is being turned off. We could turn off
>quotas when remounting read-only. As we turn them off during umount, it
>probably makes sence to turn them off on remount-ro as well.

Objection. XFS handles quotas differently that does not involve
modifying a file on the fs, so quotas could stay on (even if it does
not make much sense) while the fs is ro.

(Hm, storing quota as files reminds me of the ugly xattr hack in
reiserfs3.)
