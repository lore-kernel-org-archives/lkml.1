Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbYJMWT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbYJMWT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 18:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759428AbYJMWTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 18:19:15 -0400
Received: from 1-1-4-20a.ras.sth.bostream.se ([82.182.72.90]:35250 "EHLO
	amd.kenjo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759233AbYJMWTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 18:19:14 -0400
Subject: Re: weird throughput on write to SATA disk
From: kenneth johansson <ken@kenjo.org>
To: Grant Grundler <grundler@google.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <da824cf30810131434r34179666kc8d075c7eecdbbae@mail.gmail.com>
References: <1223925629.3947.7.camel@duo>
	 <da824cf30810131407m1a73bd11xa30fd118ee5a4c8f@mail.gmail.com>
	 <1223932956.3947.22.camel@duo>
	 <da824cf30810131434r34179666kc8d075c7eecdbbae@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 00:19:11 +0200
Message-Id: <1223936351.3947.41.camel@duo>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 14:34 -0700, Grant Grundler wrote:
> On Mon, Oct 13, 2008 at 2:22 PM, kenneth johansson <ken@kenjo.org> wrote:
> > On Mon, 2008-10-13 at 14:07 -0700, Grant Grundler wrote:
> >> On Mon, Oct 13, 2008 at 12:19 PM, kenneth johansson <ken@kenjo.org> wrote:
> >> > When writing data to /dev/sdb (that is the whole disk and no filesystem)
> >> > it starts out ok around 100MB/sec but soon end up doing considerably
> >> > worse. For prolonged times lasting several minutes it hovers in the
> >> > 20-30MB/sec.
> >>
> >> Is the application using "O_DIRECT"?
> >
> > no just open then write no fancy stuff
> >
> >> If not, could be issue with how VM writeback is (not) working.
> >
> > the access pattern is the simplest possible. Is there any knobs I could
> > try to adjust.
> >
> >> Can you reproduce this using fio or even "dd"?
> >> (See git://git.kernel.dk/fio)
> >
> > dd is having the same effect.
> 
> Can you try "dd oflag=direct if=/dev/null of=/dev/sdb bs=64k"?

I changed to use O_DIRECT and it's much more consistent now. 69-75 with
74 about 95% of the time. the disk is supposed to have 105 115 sustained
data rate. 



