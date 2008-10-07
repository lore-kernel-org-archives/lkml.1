Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYJGPoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYJGPoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbYJGPoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:44:19 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:21434 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753727AbYJGPoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:44:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GkOvNdZMkUSRnjK0wPCQQwhuUoC4vBV2B4p8fX8dHQaEaiBemF2H3tHUGIMidaLlY4E+G+G7emrW6Lkf+bjTROzNT20iQ9bq72UapsZ2+ALySS7sw4vOvp6Ls6DsEtAmCvHtw1EfLNjCcdr1KH+xGrO+x03Hy5NDQ7P6eB+hz8Q=  ;
X-YMail-OSG: VEAYmUoVM1k8ujKBoXCqqhUfzL7eNnYRc03wi32XYvARyi3IstOoQTftUx2Mz0F8GCgnxkwMVeXlFtoAfU_mIQZS37FEybNTJzSDbXuZ4juRIjUB0L6UHFcm_leOdH3g_o8a67r2ju88z4cFoBT2B2Suw.z3lxjPcHYEfgey4bk116er5pE-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [Bug #11569] Don't complain about disabled irqs when the system has paniced
Date: Wed, 8 Oct 2008 02:44:06 +1100
User-Agent: KMail/1.9.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.qTH.6475IB@wind> <20081006060238.GB3180@one.firstfloor.org>
In-Reply-To: <20081006060238.GB3180@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080244.06958.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 October 2008 17:02, Andi Kleen wrote:
> On Sat, Oct 04, 2008 at 07:32:54PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11569
> > Subject		: Don't complain about disabled irqs when the system has paniced
> > Submitter	: Andi Kleen <andi@firstfloor.org>
> > Date		: 2008-09-02 13:49 (33 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122036356127282&w=4
>
> The problem is actually worse than this description suggests. I updated
> the bugzilla entry now.
>
> The new smp_call_function() that is called from panic is quite unsuitable
> for this task:
> - It allocates memory (not a good idea in panic0
> - It complains about interrupt off
> - This whole thing breaks at least machine checks

Why doesn't it use something like nmi_shootdown_cpus on panic rather than
the (I guess less reliable and longer latency) smp_send_stop?
