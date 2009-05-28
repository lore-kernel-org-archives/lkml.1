Return-Path: <linux-kernel-owner+w=401wt.eu-S1763428AbZE1O1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763428AbZE1O1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZE1O0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:26:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:5517 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbZE1O0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:26:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RRNoPU9X1hXlxTQSsb4YPH2hQ7NILgXR7IBey0lBl8CHDBSldGL18DW0Ox/261PiER
         O4cbAklnOmSNknFyxrCAcn+nKW/QNIpbbTx1RnnNCLLMPFQakl583TaeYpzGtuIgzCg3
         wx4DvQL6qWKj1H/6EO5EwWQ5qQm4memkMIQ8o=
MIME-Version: 1.0
In-Reply-To: <20090528001350.GD26820@elte.hu>
References: <4A1C3453.6080402@redhat.com>
	 <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>
	 <20090528001350.GD26820@elte.hu>
Date: Thu, 28 May 2009 15:26:56 +0100
X-Google-Sender-Auth: 50c0173e0b6ef04b
Message-ID: <de76405a0905280726j2324b49fg4c3d8b96c267cae1@mail.gmail.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
From: George Dunlap <George.Dunlap@eu.citrix.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 1:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> > I think the Xen design has merit if it can truly make dom0 a
>> > guest -- that is, if it can survive dom0 failure.  Until then,
>> > you're just taking a large interdependent codebase and splitting
>> > it at some random point, but you don't get any stability or
>> > security in return.

Let me turn this around: are you (Ingo) saying that if a Xen system
could successfully survive a dom0 failure, then you would consider
that a valid reason for this design choice, and would be willing to
support and pursue changes required to allow mainline linux to run as
dom0?  If not then this line of discussion is just a distraction.

I personally think the strongest argument for an interdependent
codebase is the ability to have a separate piece of software as a
dedicated hypervisor. I also think Xen provides extra security and
stability as it is right now.  The code is much smaller and simpler
than the kernel.  The number of hypercalls is smaller than the number
of system calls, and the complexity of hypercalls is much lower than
the complexity of system calls in general.  Driver domains, in which a
driver runs in a domain other than dom0 and can fail and reboot, have
been supported in Xen for years.  The ability to survive dom0 failure
is just an added benefit.

As Dan and Jeremy said, the Xen community is actively pursuing the
changes required to allow dom0 to panic / reboot without requiring a
reboot of Xen and other guests.  I'm sure if that would make members
of the linux community actively support inclusion of dom0 support, we
could make that work a priority.

 -George
