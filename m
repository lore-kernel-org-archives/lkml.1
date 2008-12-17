Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760161AbYLQHnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbYLQHnA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbYLQHms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:42:48 -0500
Received: from mailgw.miraclelinux.com ([122.216.84.157]:10604 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbYLQHmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:42:47 -0500
Date: Wed, 17 Dec 2008 16:42:43 +0900
From: Yoshihiro Takahashi <ytakahashi@miraclelinux.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Huang Ying <ying.huang@intel.com>, kexec@lists.infradead.org,
        Bernhard Walle <bwalle@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kdump hangs up by Sysrq+C trigger in high load.
Message-Id: <20081217164243.a7710ae3.ytakahashi@miraclelinux.com>
In-Reply-To: <20081216110949.GB4299@elte.hu>
References: <20081216152143.88caba51.ytakahashi@miraclelinux.com>
	<20081216110949.GB4299@elte.hu>
Organization: miraclelinux.com
X-Mailer: Sylpheed 2.6.0beta1 (GTK+ 2.10.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo. Thank you, your reply.

I will serch it again.

On Tue, 16 Dec 2008 12:09:49 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yoshihiro Takahashi <ytakahashi@miraclelinux.com> wrote:
> 
> > Hi.
> > 
> > kdump hangs up by Sysrq+C trigger once in about 10 times in high load. 
> > After the above occurs, kdump cannot collect vmcores with NMI button. 
> > When waiting_for_crash_ipi does case more than 0, mdelay seem to make a 
> > stall.
> > 
> > While nmi_shootdown_cpus(), mdelay may not work since interruption is 
> > disable.  (ex. when crashing kernel by NMI interruption, all 
> > interruption may be disabled.).
> > 
> > So I think that it should use other way (TSC) instead of mdelay() in 
> > nmi_shootdown_cpus().
> 
> mdelay uses either the tsc or CPU loops - neither stop while IRQs are 
> disabled.
> 
> Could you figure out exactly why it hangs in your case?
> 
> 	Ingo
