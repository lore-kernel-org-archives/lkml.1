Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbYFLDvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbYFLDvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 23:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbYFLDve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 23:51:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:22353 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbYFLDvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 23:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=kTAEo51rnp9aarEcqHZbfpnbv4eEiclrns646JSCMsTpYbUSTAAGb1v3ZAVasKRM3r
         RTiGIHdBvJAFp0Ani1YdHSD+Vg6egKYdie6yQ9zaqwV3XtYO3lebTTI6XGCEJjAvjJdo
         fRjPAjPjaMcMATTZVHLar2KGDDI5ZBijymLtE=
Message-ID: <48509D40.2060901@gmail.com>
Date: Thu, 12 Jun 2008 12:51:28 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: CDC_PLAY_AUDIO check in cdrom_count_tracks() and other oddities
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

I'm tracking down a bug where HAL doesn't mount media automatically.
It turned out that CDROM_DISC_STATUS wasn't reporting correct disc
type which was caused by CDC_PLAY_AUDIO check failure at the top of
cdrom_count_tracks().

I've went through MMC-3 but couldn't find anything which associates
play audio capability with READ_TOC.  READ_TOC was mandatory command,
so according to MMC-3, there's no reason to avoid issuing READ_TOC on
!CDC_PLAY_AUDIO.  Is there something I don't know?

Thanks.

-- 
tejun
