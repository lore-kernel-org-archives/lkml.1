Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbYEZQUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbYEZQUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 12:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYEZQUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 12:20:38 -0400
Received: from outbound-mail-10.bluehost.com ([69.89.17.210]:44586 "HELO
	outbound-mail-10.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753160AbYEZQUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 12:20:37 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [patch, -git] pcie hotplug bootup crash fix
Date: Mon, 26 May 2008 09:20:15 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, drzeus-list@drzeus.cx,
       kristen.c.accardi@intel.com
References: <20080524165828.GA29993@elte.hu> <20080526015232.5faac5bb.akpm@linux-foundation.org> <483A9050.5000206@jp.fujitsu.com>
In-Reply-To: <483A9050.5000206@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805260920.15912.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 26, 2008 3:26 am Kenji Kaneshige wrote:
> Andrew Morton wrote:
> > On Mon, 26 May 2008 10:47:09 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:
> >>> I updated Ingo's patch. If it's ok, I'll send it to Jess Barnes with
> >>> some other patches for the other pciehp regression problems.
> >>
> >> looks good to me, thanks Kenji.
> >
> > It's a bit sad to add a large workaround like this.  I'm surprised
> > that fixing it properly is considered unviable for 2.6.26.  Normally
> > these fixes are pretty simple - just request the IRQ a bit later?
>
> Although I have not considered how to implement proper fix deeply,
> I don't think it's so simple. For example, current pciehp is doing
> like this:
>
> (1) some initialization
> (2) request_irq()
> (3) issue command
> (4) initialize slot data structure
>
> Maybe we want to do (2) after (4) to fix the problem. But if we
> simply move (2) after (4), we cannot detect the command completion
> event at (3) and it will cause command timeout.
>
> It's just an example, and there might be other things like this.
> This example might be fixed simply, but all my worry is that fixing
> this quickly might cause another regressions. This is why I think
> Ingo's approach is better in a short term.
>
> And another reason is I'm very nervous because I already caused
> many problems in pciehp since 2.6.26-rcX... :(

But you also fixed the problems, which is even more important! :)  I'm ok with 
the workaround for 2.6.26 as long as we can get a more proper fix into 
2.6.27.

Any thoughts, Kristen?

Thanks,
Jesse

