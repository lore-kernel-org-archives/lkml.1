Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbZFSUJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbZFSUJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 16:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbZFSUJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 16:09:40 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:52484 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZFSUJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 16:09:40 -0400
Subject: Re: [tpmdd-devel] TPM drivers support and Linux Integrity Module
 for 2.6.30
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: "\"dds" =?UTF-8?Q?=28=E2=98=95=29=22?= <dds@google.com>,
       seiji.munetoh@gmail.com, tpmdd-devel@lists.sourceforge.net,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Shahbaz Khan <shaz.linux@gmail.com>
In-Reply-To: <1245185391.2848.30.camel@localhost.localdomain>
References: <20cbb9450906112259m176153c9ucfa7a4d14642949f@mail.gmail.com>
	 <1244817141.3401.7.camel@dyn9002018117.watson.ibm.com>
	 <4A3474BD.4000804@linux.vnet.ibm.com>
	 <b8394ab90906140015h793aaf51rb9b105910e61fa1@mail.gmail.com>
	 <1245007238.10712.5.camel@blackbox>
	 <1245068894.3247.22.camel@dhcp231-142.rdu.redhat.com>
	 <4A367093.6010206@linux.vnet.ibm.com> <4A36C04B.6070204@linux.vnet.ibm.com>
	 <1245185391.2848.30.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 17:09:36 -0300
Message-Id: <1245442176.31915.49.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 16:49 -0400, Eric Paris wrote:
> On Mon, 2009-06-15 at 18:42 -0300, Rajiv Andrade wrote:
> > > 2- Forget manufacturer_id and base the decision on the PNP_ID as david
> > > suggested. I previously considered it but since it would end up in
> > > modifying tpm_tis_init() prototype (struct device * to struct pnp_dev *)
> > > and then wouldn't work when loading as a module with force option on, so
> > > I moved to the manufacturer_id approach.
> > >
> > > I'll get back to #2 meanwhile and post the patch, seems not hard to
> > > accomplish though..
> > >   
> > Yes, it wasn't hard, at all, just get the id with to_pnp_dev(dev)->id.
> > 
> > However, the chip is buggy, there's no reason to make a compliant
> > upstream code modify its behavior just due an 'exception' for a not
> > compliant hardware.
> > No need to worry about it too though, the workaround is available as I
> > pointed earlier (Seiji's)...
> 
> Wait what?  we refuse to work around buggy hardware that is shipping in
> LOTS of hardware (all the currently shipping lenovo thinkpads) even
> though the fix is easy?  This doesn't sound right.....

I didn't refuse to work on it... That depends on the meaning in this
context. My point is: not make an exception in the upstream code due a
buggy hardware (that's what that easy 'fix' does). Other than David's
patches, there is a workaround available as I said: 

http://sourceforge.net/mailarchive/message.php?msg_name=f02dbbe70812012308n32dc9fd6hd1f04d3ef6e002b7%40mail.gmail.com 

The only Lenovo thinkpad model I know that has it is the X200. If Intel
is indeed still shipping it buggy (therefore more and more unaware users
are buying it), that's another story. Can you confirm that?
The best would be to hear something from Intel, if they are planning to
fix it, discontinue it, do nothing about it or anything else.
Do you know how to do it or if that's possible?

More, that's only one bug. With the workaround in hands and being able
to load the module, did you run any regression tests? (Sorry for asking
that, but, again, I don't have this chip):

Thanks,
Rajiv


