Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbYACPPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbYACPPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYACPO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:14:59 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:7928 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbYACPO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:14:58 -0500
Date: Thu, 3 Jan 2008 16:14:29 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] sample kset/ktype/kobject implementation code
Message-ID: <20080103161429.59cea05d@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071220003135.GC15129@kroah.com>
References: <20071220003031.GA15129@kroah.com>
	<20071220003135.GC15129@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 16:31:35 -0800,
Greg KH <greg@kroah.com> wrote:

> 	/*
> 	 * Initialize and add the kobject to the kernel.  All the default files
> 	 * will be created here.  As we have already specified a kset for this
> 	 * kobject, we don't have to set a parent for the kobject, the kobject
> 	 * will be placed beneath that kset automatically.
> 	 */
> 	retval = kobject_init_and_add(&foo->kobj, &foo_ktype, NULL, "%s", name);
> 	if (retval) {
> 		kfree(foo);
> 		return NULL;
> 	}

I really hate to say this, but the example is still wrong. There needs
to be a kobject_put(&foo->kobj) instead of the kfree(foo) (as the
comments for kobject_init_and_add() resp. kobject_add_ng() correctly
explain :))
