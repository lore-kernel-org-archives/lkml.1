Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbXE3XgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbXE3XgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXE3XgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:36:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:42846 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbXE3XgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:36:16 -0400
Date: Wed, 30 May 2007 16:34:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/fork.c:385
Message-Id: <20070530163413.87ecfe18.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0705301630360.3568@schroedinger.engr.sgi.com>
References: <617E1C2C70743745A92448908E030B2A01929C15@scsmsx411.amr.corp.intel.com>
	<Pine.LNX.4.64.0705301630360.3568@schroedinger.engr.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 16:31:35 -0700 (PDT) Christoph Lameter wrote:

> On Wed, 30 May 2007, Luck, Tony wrote:
> 
> > 
> > > `.exit.text' referenced in section `.init.text' of drivers/built-in.o: 
> > > defined in discarded section `.exit.text' of drivers/built-in.o
> > 
> > 
> > This one is a fatal error ... the code is trying to call a function
> > that has been marked __exit in a driver that has been built-in, instead
> > of as a module.  Since a builtin driver can never be unloaded, the kernel
> > has thrown away all the __exit routines (at link time).
> > 
> > The error message appears less than helpful in tracking down which
> > routine in which driver is the problem though.
> 
> Right. I have no idea where to look. The function has no name? Or is the 
> segment .exit.text referenced by namne in .init.text?

Maybe 'objdump drivers/built-in.o and then grep that output (file)
for /exit.text/ ...


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
