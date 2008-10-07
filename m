Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbYJGBJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbYJGBJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYJGBJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:09:39 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:23119 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYJGBJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:09:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cuR7oZLyuaaFwwTA/GAdYK6Vdf574agac5EnVg8fsw8Sp4mkrrWQYMOJP1DzdSzKXq
         QcfCUJpX3OFeIYb/ByFOpHarG1YnusXjFc/SAUlyoztV4h2asNiaUpupB5x176dsDyVt
         d1IepsyPfBB7hQQ5Xi+att/rYSIuGR+jrNxuQ=
Message-ID: <48EAB672.3010209@gmail.com>
Date: Tue, 07 Oct 2008 10:08:02 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Linda Walsh <lkml@tlinx.org>
CC: Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
References: <Pine.LNX.4.64.0809142159550.18213@gc.phys.uwm.edu> <48E1B8F8.3090205@gmail.com> <48E26BDA.8080804@tlinx.org> <48E26E61.2010705@gmail.com> <48E34BC8.3050009@tlinx.org> <48E6DE07.70706@gmail.com> <48EAAF2E.4060407@tlinx.org>
In-Reply-To: <48EAAF2E.4060407@tlinx.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:
> So the real problem is why issuing a smart command isn't re-starting
> the drive -- or bringing it back from standby.  Whereas a "normal" disk
> read seems to bring it back to normal functioning just fine (and can
> then do the smart-test).
> 
> Does this give anyone ideas about where the problem might be?  Also
> sorta explains why my hangs have been infrequent, because I've been
> periodically polling the temps of all the drives -- and only when I stop
> the polling would the drive timeout, then die the next morning when
> smartd tried to run a short test between 1 and 2 am.

Sounds like a firmware problem to me.  Issuing ATA_CMD_VERIFY on block
0 before issuing test commands should work around the problem.  Also,
which controller are you using?  Can you post the failing kernel log?

-- 
tejun
