Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYIKT2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYIKT2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYIKT2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:28:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45313 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYIKT2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:28:46 -0400
Subject: Re: [PATCH 1/2] audit: fix NUL handling in untrusted strings
From: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
To: John Dennis <jdennis@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-audit <linux-audit@redhat.com>,
       viro@zeniv.linux.org.uk, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48C96D90.70608@redhat.com>
References: <1221085418.2705.19.camel@amilo>
	 <1221143113.2992.9.camel@localhost.localdomain>
	 <48C955C8.2000602@redhat.com> <1221156612.17533.14.camel@amilo>
	 <48C96D90.70608@redhat.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 11 Sep 2008 21:27:40 +0200
Message-Id: <1221161260.17533.30.camel@amilo>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Dennis píše v Čt 11. 09. 2008 v 15:12 -0400:
> Miloslav Trmač wrote: 
> > John Dennis píše v Čt 11. 09. 2008 v 13:30 -0400:
> >   
> > > Special processing with regards to the presence or absence of a null
> > > byte is one example of prohibited interpretation.
> > >     
> > This is UNIX, "string" means "NUL-terminated string" (in fact the
> > presence of a NUL byte is the only way to reasonably detect binary
> > data). 
> >   
> A primary purpose of the audit system is to log with the greatest
> accuracy possible the actual data. If that data somehow contained a
> null, even in a context in which a null would have been prohibited,
> the audit system absolutely needs to be able to correctly record that
> aberrant event and it's actual data. If the audit system failed at
> that moment it's failing at the worst possible moment, the moment when
> you're looking for bad data.
If the interface says "NUL-terminated string", any bytes after that are
not "actual data".  The bytes might be useful for diagnosing an anomaly
if the kernel's behavior somehow depended on the bytes after NUL due to
a kernel bug - but the kernel's behavior might depend on anything due to
such a bug, and we don't log the complete state of the system in each
audit message.  The "actual data" of a string is only up to the NUL
byte.

> It would be wrong for the audit system to assume the memory block it
> was pointed to only ever contained null terminated ascii strings,
> especially when the memory block is terminated by virtue of an octet
> count.
Yes, that's why it was wrong to use audit_*string() for TTY input data.
And the 2/2 patch fixes it - at the source of the problem, not in an
unrelated function that was incorrectly used.
	Mirek

