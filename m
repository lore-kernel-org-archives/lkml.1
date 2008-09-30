Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYI3R3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYI3R3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYI3R2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:28:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:39864 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYI3R2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:28:51 -0400
Date: Tue, 30 Sep 2008 10:28:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, morgan@kernel.org,
       selinux@tycho.nsa.gov
Subject: Re: [PATCH] capability: WARN when invalid capability is requested
 rather than BUG/panic
Message-ID: <20080930102840.1dbd0c48@infradead.org>
In-Reply-To: <1222795350.28251.98.camel@localhost.localdomain>
References: <1222782946.28251.63.camel@localhost.localdomain>
	<alpine.LRH.1.10.0810010008130.2068@tundra.namei.org>
	<1222785389.28251.83.camel@localhost.localdomain>
	<20080930153820.GA28616@us.ibm.com>
	<1222790843.28251.92.camel@localhost.localdomain>
	<20080930162830.GB31779@us.ibm.com>
	<1222795350.28251.98.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 13:22:30 -0400
Eric Paris <eparis@redhat.com> wrote:
> 
> No argument from me that patching up for buggy drivers sucks.  Yours
> would be less overhead, and it would return the cap system back to
> pre-2.6.25 operation (garbage in garbage out but no panic).  Since we
> already have the branch in SELinux its no 'extra' overhead to EPERM
> there instead of here (garbage in EPERM out).

to be honest, this is really a case of 
panic("This stuff is really borken")

if it passes some random value, what other api's does it pass a random
value to ?

(and in addition, random values to security critical APIs deserve a
process kill, because it could well be an exploit attempt at guessing
something. At least by not letting it live it's harder to get such type
of exploits to be able to guess things. So imo, BUG() is the right
answer)




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
