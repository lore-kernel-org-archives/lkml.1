Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975Ab0AQAM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0AQAM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 19:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663Ab0AQAMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 19:12:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:40397 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0AQAMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 19:12:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TyqsxwqvhuroVilMGxxxg8QK++I6oAkMlwQEqW161m9ib6fchOQdHC+eN8EN2UaK8G
         Y29h5Sz5baGxGQiq2PEmeZzrWhF8JUSNq6QBsdk+Y5JRdWbogOfl5zK0VlIhchhUA8C0
         C/+6WfPixtkJFauhaXn5TJllAsMG5sZUfPY2k=
MIME-Version: 1.0
In-Reply-To: <1263603503.5007.134.camel@localhost.localdomain>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> 
	<20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com> 
	<1263467289.4244.288.camel@laptop> <1263498366.4875.25.camel@localhost.localdomain> 
	<1263546175.4244.342.camel@laptop> <1263589634.5007.34.camel@localhost.localdomain> 
	<1263592192.4244.488.camel@laptop> <1263603503.5007.134.camel@localhost.localdomain>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sat, 16 Jan 2010 19:12:28 -0500
Message-ID: <3e8340491001161612x11873abdi4b74e47309e5bdfd@mail.gmail.com>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 7:58 PM, Jim Keniston <jkenisto@us.ibm.com> wrote:

> 4. Emulation removes the need for the XOL area, but requires pretty much
> total knowledge of the instruction set.  It's also a performance win for
> architectures that can't do #3.  I see kvm implemented on 4
> architectures (ia64, powerpc, s390, x86).  Coincidentally, those are the
> architectures to which uprobes (old uprobes, with ubp and xol bundled
> in) has already been ported (though Intel hasn't been maintaining their
> ia64 port).  So it sort of comes down to how objectionable the XOL vma
> (or page) really is.

On x86 at least, wouldn't one option to be to run the instruction to
be emulated in CPL ('ring') 2, from a XOL page above the user-kernel
split, not accessible to userspace at CPL 3? Linux hasn't
traditionally used anything other than CPL 0 and CPL 3 (plus CPL 1 on
Xen), but it would seem to avoid many of the problems here - it's
invisible to normal userspace code and so doesn't pollute userspace
memory maps with kernel-private stuff, but since it's running at a
higher CPL than the kernel, we can still protect kernel memory and
protect against privileged instructions.
