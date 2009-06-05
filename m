Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbZFEBWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbZFEBWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 21:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZFEBWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 21:22:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:25195 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZFEBWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:22:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,307,1241420400"; 
   d="scan'208";a="419031798"
Subject: Re: [patch] x64: Avoid irq_chip mask/unmask in fixup_irqs for
 interrupt-remapping
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "travis@sgi.com" <travis@sgi.com>, "steiner@sgi.com" <steiner@sgi.com>,
       Gary Hade <garyhade@us.ibm.com>
In-Reply-To: <1244164694.27006.10374.camel@localhost.localdomain>
References: <1244141989.27006.10369.camel@localhost.localdomain>
	 <m1iqjbd243.fsf@fess.ebiederm.org>
	 <1244164694.27006.10374.camel@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 04 Jun 2009 18:19:43 -0700
Message-Id: <1244164783.27006.10375.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-04 at 18:18 -0700, Suresh Siddha wrote:
> On Thu, 2009-06-04 at 16:13 -0700, Eric W. Biederman wrote:
> > Suresh Siddha <suresh.b.siddha@intel.com> writes:
> > 
> > > From: Suresh Siddha <suresh.b.siddha@intel.com>
> > > Subject: x64: Avoid irq_chip mask/unmask in fixup_irqs for interrupt-remapping
> > >
> > > In the presence of interrupt-remapping, irqs will be migrated in the
> > > process context and we don't do (and there is no need to) irq_chip mask/unmask
> > > while migrating the interrupt.
> > >
> > > Similarly fix the fixup_irqs() that get called during cpu offline and avoid
> > > calling irq_chip mask/unmask for irqs that are ok to be migrated in the
> > > process context.
> > >
> > > While we didn't observe any race condition with the existing code,
> > > this change takes complete advantage of interrupt-remapping in
> > > the newer generation platforms and avoids any potential HW lockup's
> > > (that often worry Eric :)
> > 
> > You now apparently fail to migrate the irq threads in tandem with
> > the rest of the irqs.
> 
> Eric, Are you referring to Gary's issues? As far as I understand, they
> don't happen in the presence of interrupt-remapping.
> 
> Can you ack this patch, as this avoid touching IO-APIC and MSI entries
> and does fixup_irqs() in a much more reliable fashion.

in the presence of interrupt-remapping ofcourse :)

> 
> I haven't followed Gary's couple of patches related to non
> interrupt-remapping case. I will go through them and see how I can help
> there.
> 
> thanks,
> suresh

