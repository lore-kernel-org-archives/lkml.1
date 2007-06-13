Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbXFMRp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbXFMRp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbXFMRpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:45:51 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:47806 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555AbXFMRpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:45:50 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Dave Hansen <hansendc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, akpm@osdl.org,
       gregkh@suse.de, mtk-manpages@gmx.net, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
In-Reply-To: <1181752649.15815.68.camel@spirit>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <1181752649.15815.68.camel@spirit>
Content-Type: text/plain
Organization: IBM
Date: Wed, 13 Jun 2007 19:42:16 +0200
Message-Id: <1181756536.29512.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Wed, 2007-06-13 at 09:37 -0700, Dave Hansen wrote:

[snip]

> I'm not sure we want to make Linux more like z/* in this regard. :)
> 
> The problem with your proposal is that every time a new message in the
> kernel is created or modified, you need somebody to go update that
> documentation.

You only have to document printks, which are using the KMSG macros.
Since there are tons of self-explaining printks, most of them do not
have to use them.

If you change the meaning of a KMSG printk and you don't update the
documentation, it is the same thing like changing a kernel API function
and forgetting to update the kernel-doc comment.

> It's going to get out-of-sync very fast if this isn't
> done, and you either need to convince and teach each and every kernel
> contributor to follow your lead, or have a team of highly trained code
> monkeys to watch git-commits and resubmit documentation for every diff
> that touches a printk. 

It is a matter of discipline. If a device driver maintainer decides to
document some messages using the KMSG macros, he has to take care that
the documentation is up-to-date. Since the printks and the descriptions
are maintained together in the kernel code, I think, that's doable. 

And the checker tool can help to keep the descriptions up-to-date, since
it produces warnings, if you use C=1 during the kernel build.

> I think it's a great idea to go and update some of these obtuse kernel
> messages with more understandable wording.  It might even be nice to
> update the Documentation/ about what kinds of messages are good or bad
> to have.  But, I just don't think this is viable to convince everybody
> to do this.

Again, not everybody has to use KMSG printks.

> Do you have a list of printks that are causing your
> customers trouble?

There are quite a lot of messages in our s390 device drivers which
should be documented. Especially for character device drivers (e.g.
tape), where the user has direct interaction with the device.

One Example from the tape device driver: "Another host has reserved the
tape device"

We should document, how to find out the host, which reserved the tape
and what has to be done on the other host in order to release the tape
etc.

> Does every printk need one of these?  What do we do with the existing
> printks?

Again: Most printks don't need documentation. We can leave them as they
are.

> Who will convert them over?  How do we enforce the rules if
> new printks must have documentation written for them?  Who writes the
> documentation if the printk author does not?

The maintainer of the component (e.g. device driver) is responsible for
the KMSG printks. If he accepts a patch, which modifies KMSG printks, he
has to take care, that the patch also updates the KMSG_DOC part.

> If we have a catalog of kernel messages, it obviously needs to be
> versioned, but does that mean that we need to keep it in the kernel
> tree?

For each kernel a separate message catalog can be automatically created.
This message catalog fits exactly to one kernel and should be installed
together with the kernel.

Michael

