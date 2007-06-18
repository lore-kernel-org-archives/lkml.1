Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbXFRXFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbXFRXFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764679AbXFRXFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:05:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933703AbXFRXFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:05:31 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [patch 1/3] Text Edit Lock - i386
Date: Tue, 19 Jun 2007 01:05:10 +0200
User-Agent: KMail/1.9.6
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, ananth@in.ibm.com, jkenisto@us.ibm.com
References: <20070618215846.247539382@polymtl.ca> <20070618220458.888939232@polymtl.ca> <46770CA9.4070304@redhat.com>
In-Reply-To: <46770CA9.4070304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706190105.10803.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 June 2007 00:52:25 Chuck Ebbert wrote:
> On 06/18/2007 05:58 PM, Mathieu Desnoyers wrote:
> > Interface to use for code patching : uses a mutex to insure mutual edit
> > exclusion and makes sure the page is writable.
> > 
> ... 
> > +/* Mutex protecting text section modification (dynamic code patching) */
> > +static DEFINE_MUTEX(text_mutex);
> > +
> 
> Probably should be a spinlock.
> 
> And it just occurred to me, how does smp_alternatives deal with this?
> Is it broken now when the text section is read-only?

The text section is only changed to ro very late,  alternative code
runs earlier.

But when you unplug all CPUs to go back to UP I suspect it may break.

-Andi
