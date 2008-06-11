Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYFKGbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYFKGbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 02:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYFKGbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 02:31:25 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:25964 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752085AbYFKGbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:31:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uWzEN445NP64RuK9cxMi0UIHB0BWmuWywT19VxByfB76IEZ6xJKdy/TPcP3L/OFiV63TXyCSmdlkUSitSqk/jXgpiK7TJgqipO9K3hzkP9AykG31BPf7lUbAo+sgABbhVdQoLMP+OYw7dxrPbwZMEEEzqW+2b1D1HhvAKGqZTXM=  ;
X-YMail-OSG: BMCZvi8VM1kbfrModu9Yw8clbCzICmuuh91uh9HQHc6l4RQUKZ1pkqwHWXULXyalvUB8UKk7ej35APmu9EL6dg_dlEFwkJZtpfR30HHjd3F_3TzyXlmljyHOOx.0dN0WOf8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc5-mm2: OOM with 1G free swap
Date: Wed, 11 Jun 2008 16:31:13 +1000
User-Agent: KMail/1.9.5
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>
References: <20080609223145.5c9a2878.akpm@linux-foundation.org> <20080611060029.GA5011@martell.zuzino.mipt.ru> <20080610232705.3aaf5c06.akpm@linux-foundation.org>
In-Reply-To: <20080610232705.3aaf5c06.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806111631.13920.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008 16:27, Andrew Morton wrote:
> On Wed, 11 Jun 2008 10:00:29 +0400 Alexey Dobriyan <adobriyan@gmail.com> 
wrote:
> > On Mon, Jun 09, 2008 at 10:31:45PM -0700, Andrew Morton wrote:
> > > - This is a bugfixed version of 2.6.26-rc5-mm1 - mainly to repair a
> > >   vmscan.c bug which would have prevented testing of the other vmscan.c
> > >   bugs^Wchanges.
> >
> > OOM condition happened with 1G free swap.
>
> Thanks for testing.  Again.
>
> > 4G RAM, 1G swap partition, normally LTP survives during much, much higher
> > load.
> >
> > vm.overcommit_memory = 0
> > vm.overcommit_ratio = 50
>
> Well I assume that Rik ran LTP.  Perhaps a merge problem.
>
> > ...
> >
> > [ 6773.608125] init invoked oom-killer: gfp_mask=0x1201d2, order=0,
> > oomkilladj=0
>
> GFP_USER
>
> > [ 6773.608215] Pid: 1, comm: init Not tainted 2.6.26-rc5-mm2 #2
>
> wot?  The oom-killer isn't supposed to kill init!

It is init that invokes the OOM killer, the actual process killed
comes at the end I believe:

 [...]

> > [ 6773.631799] Out of memory: kill process 4788 (sshd) score 11194 or a
> > child [ 6773.631876] Killed process 4789 (bash)
