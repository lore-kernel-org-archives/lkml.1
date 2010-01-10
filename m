Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674Ab0AJENN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab0AJENN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 23:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136Ab0AJENM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 23:13:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:44503 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab0AJENM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 23:13:12 -0500
Date: Sat, 9 Jan 2010 20:15:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Dimitrios Apostolou <jimis@gmx.net>, Alex Chiang <achiang@hp.com>,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258
  (fwd)
Message-ID: <20100109201527.77dd1714@infradead.org>
In-Reply-To: <2c0942db1001091807k542b1052s96111775d6431bd0@mail.gmail.com>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain>
	<20100108171513.GB22713@ldl.fc.hp.com>
	<20100109134352.3dedd4ea@infradead.org>
	<alpine.LNX.2.00.1001100155370.1325@localhost.localdomain>
	<20100109160836.26a344a9@infradead.org>
	<alpine.LNX.2.00.1001100226570.1325@localhost.localdomain>
	<20100109164240.43b21247@infradead.org>
	<2c0942db1001091807k542b1052s96111775d6431bd0@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jan 2010 18:07:14 -0800
Ray Lee <ray-lk@madrabbit.org> wrote:

> On Sat, Jan 9, 2010 at 4:42 PM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > basically it appears that your machine, when the kernel asks for C2,
> > exits C2 immediately again.
> >
> > The old algorithm somehow caught this and stopped asking for C2
> > most of the time; the new algorithm doesn't see any activity and
> > asks for C2 again.
> 
> This change of behavior will certainly bite more users out there. Is
> there any way we can detect the systems that aren't honoring the C2
> request and limit back to C1?

it's not very likely that there are many such systems; it takes work to
break C2....
so far in 6 months 2 systems showed up, and this includes a fedora
release.

on the other hand, it's not so easy to detect the situation; exiting c2
quickly can also happen in normal use, so we'd have to have some sort of
threshold, which will be fragile by itself.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
