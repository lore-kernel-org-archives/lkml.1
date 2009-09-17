Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbZIQVcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbZIQVcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZIQVcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZIQVcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:32:09 -0400
Subject: Re: kernel panic - not syncing: out of memory and no killable
 processes
From: Eric Paris <eparis@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <alpine.DEB.1.00.0909171417020.19006@chino.kir.corp.google.com>
References: <1253158603.5213.204.camel@dhcp231-106.rdu.redhat.com>
	 <1253191435.5213.209.camel@dhcp231-106.rdu.redhat.com>
	 <alpine.DEB.1.00.0909171326340.31112@chino.kir.corp.google.com>
	 <1253219756.5213.348.camel@dhcp231-106.rdu.redhat.com>
	 <1253221309.5213.350.camel@dhcp231-106.rdu.redhat.com>
	 <1253222149.5213.352.camel@dhcp231-106.rdu.redhat.com>
	 <alpine.DEB.1.00.0909171417020.19006@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Sep 2009 17:31:59 -0400
Message-Id: <1253223119.5213.359.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 14:24 -0700, David Rientjes wrote:
> On Thu, 17 Sep 2009, Eric Paris wrote:

> Looks udevd related, and you mentioned that this is the point where it 
> always panics in your initial report.  It doesn't appear to be a VM issue.  
> Finding that change between next-20090911 and next-20090914 may be time 
> consuming.

Absolutely 100% udevd related.  It always pops right when udev starts.
Every time.  I don't know how to get that to come out on the serial
port, you only get to see the kernel messages (although there is nothing
on the screen other than "Starting udev"

Reverting 3f2aa307c4d26b4ed6509d0a79e8254c9e07e921 causes the problem to
go away.  I now am running a 79b520e87e kernel + your patch (adding
console_verbose()) + reverting 3f2aa307c4d2 and it seems to be working.

-Eric

