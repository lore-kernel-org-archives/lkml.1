Return-Path: <linux-kernel-owner+w=401wt.eu-S1760940AbYCGO5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbYCGO5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 09:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbYCGO5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 09:57:31 -0500
Received: from relay2.sgi.com ([192.48.171.30]:59585 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758119AbYCGO5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 09:57:19 -0500
Date: Fri, 7 Mar 2008 08:57:03 -0600
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, mingo@elte.hu,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080307085703.123fe896.pj@sgi.com>
In-Reply-To: <6599ad830803070047l1b108fc5je19791362291018@mail.gmail.com>
References: <20080227222103.673194000@chello.nl>
	<20080304013534.4e51ae48.pj@sgi.com>
	<1204628762.6241.46.camel@lappy>
	<47CDA885.3000103@qualcomm.com>
	<20080304191159.a02be58b.pj@sgi.com>
	<1204706272.6241.79.camel@lappy>
	<20080306074729.6233e537.pj@sgi.com>
	<1204816885.6241.265.camel@lappy>
	<20080306214003.aba81840.pj@sgi.com>
	<20080307003924.6dcb16a3.pj@sgi.com>
	<6599ad830803070047l1b108fc5je19791362291018@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> An alternative would be to just have some kind of "irqsets" file in
> the top-level cpuset directory and let the user write irq group
> definitions into that file.

Yes, exactly, that's the alternative.

I tried that, in my mind, and got stuck on the complicated syntax that
would have been needed to represent an arbitrary length array of named
lists of irqs with each list having a priority attribute.

So I went with the separate "irqs.N.name" files, (ab)using the file
system directory apparatus to handle the "arbitrary length array of
named" entities aspect, burying the priority attribute (N) in the name,
and leaving each individual irqs.N.name file only needing to hold a
single vector of irq numbers.

A security conscious sysadmin can even assign different permissions to
the different irq lists with this.  And updates of one irq list don't
endanger the other irq lists, thanks to the innate and elaborate
capabilities in the kernel vfs code to handle concurrent updates to
separate files correctly and reliably.

This reminds me of the difference between the Windows Registry (one big
awful file) and the Unix /etc directory (2745 files, on the system
nearest to my shell prompt.)  Well, in this irq case, the different is not
-that- dramatic, but it is a small echo of such.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
