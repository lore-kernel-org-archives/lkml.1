Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbXLTHaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbXLTHaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 02:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXLTH35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 02:29:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:56497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbXLTH35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 02:29:57 -0500
Subject: Re: [RFC] kobject/kset/ktype documentation and example code updated
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0712192237140.15674-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0712192237140.15674-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 08:27:19 +0100
Message-Id: <1198135639.2662.54.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+8IF+zzxVEeENBrGQ6arjq5t1Oo6CnlmytqtA
 6wrM5SIQIoi6F1FN6Urb2Pfl4/5Ek2Noh3Fz5o9H79+ahpk+0z
 Q1oMQ1Se0TnYhrMfd/aoTNNo8crX2es
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-19 at 23:26 -0500, Alan Stern wrote:
> On Wed, 19 Dec 2007, Greg KH wrote:

> > associated with a kobject, then the parent for the kobject can be set to
> > NULL in the call to kobject_add() and then the kobject will be placed under
> > the kset itself.
> 
> "and then the kobject's parent will be set to the kset itself."
> 
> Kay, in my version of kobject_add() it says:
> 
> 	if (kobj->kset) {
> 		kobj->kset = kset_get(kobj->kset);
> 
> 		if (!parent) {
> 			parent = kobject_get(&kobj->kset->kobj);
> 			/*
> 			 * If the kset is our parent, get a second
> 			 * reference, we drop both the kset and the
> 			 * parent ref on cleanup
> 			 */
> 			kobject_get(parent);
> 		}
> 
> That last call to kobject_get(parent) doesn't make sense.  The code has
> already taken two references to the kset: one in the assignment of
> kobj->kset and the other in the assignment of parent.  The final
> kobject_get() then acquires a third reference, which will never be
> dropped.

Yeah, that's wrong, and caused by two patches trying to solve the same
problem. We had users assigning the kset before kobject_init() and users
doing that after it. We moved the kset referencing from kobiect_init to
kobject_add, which introduced the third reference, while we already
added the second one to fix the issues. We could drop one of the patches
in the series, but this is all already gone with the latest changes in
Greg's tree.

Thanks,
Kay

