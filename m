Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbYBBN7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbYBBN7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 08:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757107AbYBBN7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 08:59:32 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39593 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbYBBN7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 08:59:31 -0500
Date: Sat, 2 Feb 2008 14:59:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [scsi bug] spurious build failures in aic7xxx
Message-ID: <20080202135935.GA23838@uranus.ravnborg.org>
References: <20080201225056.GA18302@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201225056.GA18302@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 11:50:56PM +0100, Ingo Molnar wrote:
> 
> i'm getting spurious build failures with latest -git:
> 
> In file included from drivers/scsi/aic7xxx/aic7xxx_proc.c:44:
> drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_pause_bug_fix':
> drivers/scsi/aic7xxx/aic7xxx_inline.h:66: error: 'CCSCBCTL' undeclared (first use in this function)
> drivers/scsi/aic7xxx/aic7xxx_inline.h:66: error: (Each undeclared 
> identifier is reported only once
> drivers/scsi/aic7xxx/aic7xxx_inline.h:66: error: for each function it 
> appears in.)
> drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_update_residual':
> 
> BUT, if i redo the build, it now builds. It's probably some generated 
> file ordering problem?

Can you give a bit more details about your build setup.
I cannot reproduce it here and I tried several combinations of
-j values and ways to specify what to build.

I would at least like to see all lines preceeding this on in your
build log so I get an understanding what happened just before you hit this.

It looks like make started updating the aic7xxx_reg.h file but failed to
finsih the job before it started building aic7xxx_proc.c so the build
of aic7xxx_proc.c picked up a half written .h file.

	Sam
