Return-Path: <linux-kernel-owner+w=401wt.eu-S1763785AbYJJTtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763785AbYJJTtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761898AbYJJTt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:49:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53951 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761600AbYJJTt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:49:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
Date: Fri, 10 Oct 2008 21:53:44 +0200
User-Agent: KMail/1.9.9
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <20081009190405.13A253CB@kernel> <200810101517.17809.rjw@sisk.pl> <20081010145422.GE11695@elte.hu>
In-Reply-To: <20081010145422.GE11695@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810102153.45174.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 10 of October 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > In the long run, could we expect a (experimental) version of 
> > > hibernation that would just use this checkpointing facility to 
> > > hibernate?
> > 
> > Surely not ACPI-compliant.
> 
> what do you mean?

The ACPI spec says quite specifically what should be done while entering
hibernation and during resume from hibernation.  We're not following that
in the current code, but we can (gradually) update the code to become
ACPI-compilant in that respect.  However, if we go the checkpointing route, I
don't think that will be possible any more. 

[In short, the problem is that ACPI regards the S4 state corresponding to
hibernation as a sleep state of the system which is therefore fundamentally
different from the soft power-off state and requires special handling.]

This may be a theory etc. (I don't want to start the entire discussion about
that once again), but clearly there's a choice to be made here.  I'd prefer
hibernation to be ACPI-compliant, but if people don't want that, I won't fight
for it.

Thanks,
Rafael
