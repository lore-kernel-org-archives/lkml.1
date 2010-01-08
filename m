Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093Ab0AHIai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab0AHIai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647Ab0AHIad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:30:33 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:36410 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0AHIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:30:31 -0500
Date: Fri, 8 Jan 2010 09:30:25 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, caiqian@redhat.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Kratochvil <jkratoch@redhat.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: s390 && user_enable_single_step() (Was: odd utrace testing
 results on s390x)
Message-ID: <20100108093025.28ec0907@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100107214642.579F27300@magilla.sf.frob.com>
References: <20100104155225.GA16650@redhat.com>
	<20100104171626.22ea2d9c@mschwide.boeblingen.de.ibm.com>
	<20100104181412.GA21146@redhat.com>
	<20100104211147.4CC94D532@magilla.sf.frob.com>
	<20100105105030.66bb8a0a@mschwide.boeblingen.de.ibm.com>
	<20100105153633.GA9376@redhat.com>
	<20100105164610.388effd3@mschwide.boeblingen.de.ibm.com>
	<20100105155913.GA10652@redhat.com>
	<20100105170301.GA13641@redhat.com>
	<20100105195818.GA20358@redhat.com>
	<20100106201722.GB26204@redhat.com>
	<20100106211329.DB4F5134D@magilla.sf.frob.com>
	<20100107101855.13248dc2@mschwide.boeblingen.de.ibm.com>
	<20100107214642.579F27300@magilla.sf.frob.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Jan 2010 13:46:42 -0800 (PST)
Roland McGrath <roland@redhat.com> wrote:

> > Clear the TIF_SINGLE_STEP bit in copy_thread. If the new process is
> > not auto-attached by the tracer it is wrong to delivere SIGTRAP to
> > the new process.
> 
> The change is right, but this log entry is confusing.  "auto-attached" has
> nothing to do with it, nor does anything about tracing the new process or
> not.  The new process has not experienced a PER trap of its own, so it is
> wrong to deliver a SIGTRAP that is meant for its creator.

Ok, I changed the wording slightly:

Clear the TIF_SINGLE_STEP bit in copy_thread. The new process did not get
a PER event of its own. It is wrong deliver a SIGTRAP that was meant for
the parent process.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

