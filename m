Return-Path: <linux-kernel-owner+w=401wt.eu-S1760080AbXK1Mh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080AbXK1Mh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbXK1Mgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:36:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:59443 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305AbXK1Mgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:36:52 -0500
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
From: Kay Sievers <kay.sievers@vrfy.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20071128100108.45fcbf15@gondolin.boeblingen.de.ibm.com>
References: <20071127230252.GB10038@kroah.com>
	 <20071128100108.45fcbf15@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 13:35:54 +0100
Message-Id: <1196253354.3242.40.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX197A7s76+tdKj3RYbC9pDt7GUvxeZCJGI/LqeY
 yBEESd1qiyv3fImbZY1s1FryjJsYB6Heo/X3CHmbwX04lJ/ZrT
 CZ21GTWxWbr4j3Zh+VJXHs/q7ZNkrj1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-28 at 10:01 +0100, Cornelia Huck wrote:
> On Tue, 27 Nov 2007 15:02:52 -0800, Greg KH <greg@kroah.com> wrote:

> > Among other things, kobject_init() sets the kobject's reference count to
> > one.  Calling kobject_init() is not sufficient, however. Kobject users
> > must, at a minimum, set the name of the kobject; this is the name that will
> > be used in sysfs entries. 
> 
> Unless they don't register their kobject. (But they should always set a
> name anyway to avoid funny debug messages, so it is probably a good
> idea to call this a "must").

Yeah, we should require it. And kobject_cleanup() needs to be called to
free the allocated name, if the object is not already added and needs to
be deleted (common in rewinding on error).

Btw, do you have a good example for unregistered/unnamed kobjects?

Thanks,
Kay

