Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYE3SVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYE3SVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 14:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYE3SUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 14:20:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46558 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbYE3SUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 14:20:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080530150515.GA30397@redhat.com>
Date: Fri, 30 May 2008 11:19:28 -0700
In-Reply-To: <20080530150515.GA30397@redhat.com> (Dave Jones's message of
	"Fri, 30 May 2008 11:05:15 -0400")
Message-ID: <m1wslb1wpb.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dave Jones <davej@redhat.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XMPlayFrnd1 XMPlayFrnd: Play Friend Spam 1 Or More Qualities
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: kernel: sysctl table check failed: /dev/parport/parport0/devices/ppdev0/timeslice Sysctl already exists
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> Well, that's umm, special.
> I wonder if powering off the printer isn't causing the sysctl to be removed,
> causing the next power-on to look like a new device ?
> Eric, you poked around the sysctl paths in parport last year, any ideas?

Yes.  The short answer is that this is a real bug in the parport code
that has existed forever.  We just now complain.

http://bugzilla.kernel.org/show_bug.cgi?id=9749

It takes something like two accessors of the parallel port to trigger
this.  Though not in a bad way.

In particular each open creates the sysctl for the duration of the
open (or something like that) and so if you open (I think it is
/dev/parport0) twice you try and create the sysctls twice.

I got as far as basic confirmation of this bug, and a rough cause of
it.  Unfortunately I have not had the time to unscramble it, and neither
it seems has anyone else.

Eric
