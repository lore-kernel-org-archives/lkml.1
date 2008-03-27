Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbYC0MES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbYC0MES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325AbYC0MEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:04:00 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:4214 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbYC0MD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:03:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nNxldWMYhZN1Jk2iQiiwfWS9PT2tvAJmrom6qzrU1mPunu5I/qLU1oDvbZbuckfPzB9aHFhYN7h4ayRybYzWHkhN9v1/SR4KByXPJ5icJy/TH/7cmxEjUsotrfO4gjNcMGkUSMcJXwxuPo6uUyqBv40ZTb+/8C8CO1ABPtT+1K8=
Subject: Re: + futex-runtime-enable-pi-and-robust-functionality.patch added
	to -mm tree
From: Josh Boyer <jwboyer@gmail.com>
To: benh@kernel.crashing.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       buytenh@wantstofly.org, mingo@elte.hu, riku.voipio@movial.fi,
       stable@kernel.org, schwidefsky@de.ibm.com
In-Reply-To: <1206589719.6926.81.camel@pasglop>
References: <200802150149.m1F1n8Gx013909@imap1.linux-foundation.org>
	 <20080216124248.GA4900@osiris.boeblingen.de.ibm.com>
	 <alpine.LFD.1.00.0802161346350.7583@apollo.tec.linutronix.de>
	 <20080216134155.GB4900@osiris.boeblingen.de.ibm.com>
	 <alpine.LFD.1.00.0802161444510.7583@apollo.tec.linutronix.de>
	 <20080216140444.GC4900@osiris.boeblingen.de.ibm.com>
	 <alpine.LFD.1.00.0802161525530.7583@apollo.tec.linutronix.de>
	 <1206588739.6926.79.camel@pasglop>  <1206589719.6926.81.camel@pasglop>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 07:03:54 -0500
Message-Id: <1206619434.4160.14.camel@vader.jdub.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 14:48 +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2008-03-27 at 14:32 +1100, Benjamin Herrenschmidt wrote:
> > > Hmm, not sure whether there is such code, but then it would be not too bad
> > > to add
> > > 
> > >    if (!p)
> > >       return -EFAULT;
> > > 
> > > to the S390 implementations which only read data and have an exception
> > > fixup.
> > 
> > I have a different problem on some embedded powerpc's where the TLB miss
> > code isn't checking for the cached pgdir pointer being NULL (which
> > happens because we are early at boot and haven't activated an mm). So we
> > end up either taking recursive faults or going into lalaland walking
> > the page tables.
> > 
> > It happens on some unreleased code, I'll verify if it happens on
> > 8xx/4xx/etc... in a minute, and will cook a patch if it does.
> 
> Ok, so everything released seems to be fine. It will use swapper_pg_dir
> which on 32 bits will do the right thing. Pfiew ! So only some stuff I'm
> still working on breaks, I'll fix it.

I try to test at least the -rc releases on 4xx as they come out, if not
a daily git update, and this never bit on 4xx for the reasons you
stated.  Glad we have similar results.

josh

