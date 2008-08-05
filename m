Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbYHEFtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbYHEFtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 01:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYHEFtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 01:49:04 -0400
Received: from po-out-1718.google.com ([72.14.252.153]:44522 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYHEFtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 01:49:01 -0400
Message-ID: <f73f7ab80808042249r4a29510foedbbae595c947028@mail.gmail.com>
Date: Tue, 5 Aug 2008 01:49:01 -0400
From: "Kyle Moffett" <kyle@moffetthome.net>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
Cc: "Eric Paris" <eparis@redhat.com>, "Greg KH" <greg@kroah.com>,
       malware-list@lists.printk.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080805005415.GA10108@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <20080804223249.GA10517@kroah.com>
	 <20080805002618.GA18215@infradead.org>
	 <1217897224.27684.66.camel@localhost.localdomain>
	 <20080805005415.GA10108@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2008 at 8:54 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Aug 04, 2008 at 08:47:04PM -0400, Eric Paris wrote:
>> On Mon, 2008-08-04 at 20:26 -0400, Christoph Hellwig wrote:
>> > NACK, this kind of policy should be done in kernelspace.
>>
>> What?  You want to write and in kernel scanner for Window viruses?
>
> No, I want a sane security policy in kernelsapce that doesn't look
> at the content because doing security by content properly is equivalent
> to solving the halting problem.  I couldn't give a rats a** about
> windows viruses as they can't actually cause any harm on a Linux
> machine.

Much better solution:

Use SELinux or another similar Mandatory Access Control labeling
system.  Mark some things as "trusted" or "privileged" or whatever
your particular labeling methodology requires.  Mark other things as
"untrusted", "unprivileged", "internet file", etc.  Disallow most
interaction between "trusted" and "untrusted" things.  Configure your
userspace virus-scanner which is allowed to read "untrusted" files and
create "semi-trusted" files in a particular directory, where they can
then be picked up by "trusted" programs.

Problem solved.  Untrusted and possibly-compromised files can't be
executed, or even if they could be they can't do anything
interesting/harmful.  In order to execute some junk you just
downloaded from the internet you have to click "Yes I accept the
security risk" and run it through whatever virus-scanner you want.
Then you copy it from the virus-scanner output directory into
somewhere else and run it.

You can do the same thing with software updates downloaded from the
internet, just replace "trusted" with "installed package",
"semi-trusted" with "valid package", "untrusted" with "just-downloaded
package file", and "virus scanner" with "package signature
verification tool".

I could easily come up with a bunch more examples if you really care that much.

Cheers,
Kyle Moffett
