Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZFNDp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZFNDp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 23:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZFNDpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 23:45:20 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:36475 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbZFNDpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 23:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=FPS9CM+1XH8jyauWh/A/8QD06Gah5FPxuRGNXs7qBAfO5cMCL3t2IoC3dtmQ3GYLT8
         AASaUQO9hSjQRg+gnI/ATSqoTPLeBUPpEPA6hadJcdW2Hj9+01DdqkLVTmrikYloU0B+
         dqrbKUGYfaO+Ru2fCExyprysMMNxRMarYFK1Q=
Date: Sun, 14 Jun 2009 12:45:17 +0900 (JST)
Message-Id: <20090614.124517.47505469.konishi.ryusuke@gmail.com>
To: llucax@gmail.com
Cc: linux-kernel@vger.kernel.org, albertito@blitiri.com.ar, users@nilfs.org,
       llucax@gmail.com, konishi.ryusuke@lab.ntt.co.jp
Subject: Re: NILFS2 get stuck after bio_alloc() fail
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20090614013211.GA22552@homero.springfield.home>
References: <20090614013211.GA22552@homero.springfield.home>
X-Mailer: Mew version 6.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Sat, 13 Jun 2009 22:32:11 -0300, Leandro Lucarella wrote:
> Hi!
> 
> While testing nilfs2 (using 2.6.30) doing some "cp"s and "rm"s, I noticed
> sometimes they got stucked in D state, and the kernel had said the
> following message:
> 
>         NILFS: IO error writing segment
> 
> A friend gave me a hand and after adding some printk()s we found out that
> the problem seems to occur when bio_alloc()s inside nilfs_alloc_seg_bio()
> fail, making it return NULL; but we don't know how that causes the
> processes to get stucked.
> 
> PS: Please CC me.
> -- 
> Leandro Lucarella (luca) | Blog colectivo: http://www.mazziblog.com.ar/blog/

Thank you for reporting this issue.

Could you get stack dump of the stuck nilfs task?
It is acquirable as follows if you enabled magic sysrq feature:

 # echo t > /proc/sysrq-trigger

I will dig into the process how it got stuck.

P.S.
nilfs.org and the nilfs mailing list is stopping due to planned power
outage.  They will be back on June 15 0:30 a.m.

A backup site except the list is available on
http://nilfs.sourceforge.net/en/ during the period.

Regards,
Ryusuke Konishi
