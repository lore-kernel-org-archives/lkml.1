Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbXFIISR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbXFIISR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbXFIISH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:18:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55304 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756703AbXFIISE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:18:04 -0400
Date: Sat, 9 Jun 2007 01:17:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Emelianov" <xemul@openvz.org>
Subject: Re: [0/1] [patch -mm] Add containerstats (v3)
Message-Id: <20070609011740.fc938ed6.akpm@linux-foundation.org>
In-Reply-To: <6599ad830706090107u63b7e8c2p8e5c65778cde7473@mail.gmail.com>
References: <20070608181346.15764.2467.sendpatchset@balbir-laptop>
	<20070608124816.fa1e70d8.akpm@linux-foundation.org>
	<6599ad830706090009q25e13ff6ybad7d7f7db21cd48@mail.gmail.com>
	<20070609010202.4c2b51fb.akpm@linux-foundation.org>
	<6599ad830706090107u63b7e8c2p8e5c65778cde7473@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007 01:07:53 -0700 "Paul Menage" <menage@google.com> wrote:

> On 6/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > - CONTAINER_DEBUG should depend on CONTAINERS
> 
> CONTAINER_DEBUG is actually a container subsystem whose sole purpose
> is to provide debugging information about any hierarchy that it's
> mounted as a part of. So in some senses it's in the same boat as
> something like cpusets or the RSS controller. CONFIG_CONTAINER_DEBUG
> doesn't affect any of the container framework code.

Oh, that's right.

But it still should depend on CONTAINERS

> >
> > - the CPUSETS && SMP is weird and should be deleted, unless I'm missing
> >   something
> 
> Cpusets depends on SMP in the vanilla tree, so that's not anything new
> that I added.

Oh, OK, so CPUSETS is nor a client of CONTAINERS: so it depneds on CONTAINERS

> >
> > - CONTAINERS should depend on CPUSETS
> 
> You mean the other way around?

yup

> >
> > - That leaves CONTAINER_CPUACCT.
> 
> Really, CONTAINER_CPUACCT should have the same relationship to
> CONTAINERS as CPUSETS does.
> 

Would it not be simplest to have CONTAINERS as the top-level
user-configurable item and to then have everything else depend on it?

select is a nasty thing - we repeatedly have problems when using it.
