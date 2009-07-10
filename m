Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZGJJrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZGJJrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbZGJJrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:47:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:36297 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZGJJro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:47:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=mdLb2WbHZUInRHmnnOU6ctkEhz1DAW4TFZA8pQkTXjeoGC+MKUIWS6hxa+56C7d1i
	/GI2uqMlOsPO5sg9k67zA==
Date: Fri, 10 Jul 2009 02:47:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, fche@redhat.com, cl@linux-foundation.org
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap
In-Reply-To: <1247218826.771.15.camel@penberg-laptop>
Message-ID: <alpine.DEB.2.00.0907100243010.14601@chino.kir.corp.google.com>
References: <1247156020.27671.40.camel@debian-nb> <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com> <20090710084745.GA26752@elte.hu> <1247215920.32044.3.camel@penberg-laptop> <20090710090351.GD14666@wotan.suse.de> <1247217263.771.8.camel@penberg-laptop>
 <20090710092921.GF14666@wotan.suse.de> <1247218826.771.15.camel@penberg-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, Pekka Enberg wrote:

> I'm not sure it's such a hard decision. SLAB is on it's way out because
> SLUB and SLQB code are much cleaner and the debugging support is better.

I don't think that is good enough reason.  CONFIG_SLAB is by far the 
optimal choice for netperf TCP_RR on >= 16 cpus and pushing it out of the 
tree, even though it is no longer the default option, isn't an option for 
those of us who live by performance even if it comes at the cost of a 
dirtier implementation (enhanced debugging support doesn't even register 
on my radar since it's useless in a production environment).
