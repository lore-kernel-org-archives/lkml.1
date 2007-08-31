Return-Path: <linux-kernel-owner+w=401wt.eu-S1761476AbXHaQyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761476AbXHaQyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbXHaQy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:54:27 -0400
Received: from smtp-out.google.com ([216.239.45.13]:26785 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271AbXHaQy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:54:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=R+acJxOQ0NzJm1J/ifcNB4AndFNmtHKpSZsiS7tWTwd3Vdr/I/w/vxD8E4Eiv9FbF
	dQIYrUWEh0lcHzaTs2G0g==
Message-ID: <6599ad830708310954y244b1043kd69264ca6628b0df@mail.gmail.com>
Date: Fri, 31 Aug 2007 09:54:13 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [ckrm-tech] Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
Cc: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       vatsa@linux.vnet.ibm.com, bob.picco@hp.com,
       linux-kernel@vger.kernel.org, "Paul Jackson" <pj@sgi.com>,
       mel@skynet.ie, nacc@us.ibm.com, "Serge E. Hallyn" <serge@hallyn.com>,
       kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com
In-Reply-To: <20070815113308.b3e16cc7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187103831.6281.24.camel@localhost>
	 <20070814204951.GA2065@vino.hallyn.com>
	 <Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com>
	 <1187127685.6281.139.camel@localhost>
	 <Pine.LNX.4.64.0708141454110.32257@schroedinger.engr.sgi.com>
	 <1187185392.5422.13.camel@localhost>
	 <20070815092954.bfe7e86d.pj@sgi.com>
	 <20070815171210.GB13286@vino.hallyn.com>
	 <1187200830.5422.39.camel@localhost>
	 <20070815113308.b3e16cc7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> I don't recall what specifically went wrong when we were using select
> in there, but it was pretty ugly.
>
> We're hitting more and more problems with this "select is
> broken"-versus-"depends-on user inferface sucks" problem.

How about if it was an error to have a "depends" and a "select" for
the same config option? That would simplify the config graph - maybe
it would avoid the problems that you'd seen before?

Alternatively, for options that aren't user-selectable, but are only
triggered by the user selecting a component that requires them (e.g.
selecting the memory controller requires containers) maybe they should
be taken out of Kconfig and just made into Makefile-derived variables?

Paul
