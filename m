Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbZEKPMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbZEKPMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZEKPM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:12:27 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:61976 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026AbZEKPM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:12:26 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18951.32643.749495.538351@drongo.ozlabs.ibm.com>
References: <20090508165219.469818319@chello.nl>
	 <20090508170028.837558214@chello.nl>
	 <18951.32643.749495.538351@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 17:12:21 +0200
Message-Id: <1242054741.11251.279.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 11:29 +1000, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > Corey noticed that ioctl()s on grouped counters didn't work on the whole group.
> > This extends the ioctl() interface to take a second argument that is
> > interpreted as a flags field. We then provide PERF_IOC_FLAG_GROUP to toggle
> > the behaviour.
> > 
> > Having this flag gives the greatest flexibility, allowing you to individually
> > enable/disable/reset counters in a group, or all together.
> 
> As far as enable/disable are concerned, I don't think this is really
> necessary.  My intention was that if you want to enable/disable a
> whole group you just enable/disable the leader and leave all its
> siblings enabled, since if the leader is disabled the whole group
> can't go on.
> 
> Corey's problem was that we have a bug where enabling the leader only
> puts the leader on and not the enabled group members.  I meant to send
> a patch to fix that ages ago but I got distracted.  I'll send out the
> patch shortly.

Thanks, I missed that little detail.

Do we still want the new ioctl iteration flag?

