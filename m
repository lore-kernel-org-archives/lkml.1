Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbXDMNWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbXDMNWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbXDMNWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:22:30 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:19221 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbXDMNW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:22:29 -0400
Date: Fri, 13 Apr 2007 15:24:53 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Markus Rechberger" <markus.rechberger@amd.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: Re: How should an exit routine wait for release() callbacks?
Message-ID: <20070413152453.571e887a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <461F6C8C.1020901@amd.com>
References: <Pine.LNX.4.44L0.0704121706040.2472-100000@iolanthe.rowland.org>
	<20070413110313.352330ce@gondolin.boeblingen.de.ibm.com>
	<461F6C8C.1020901@amd.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 13:42:04 +0200,
"Markus Rechberger" <markus.rechberger@amd.com> wrote:

> seems like you have the same problem as the dvb framework has/had.
> 
> http://mcentral.de/hg/~mrec/v4l-dvb-stable
> 
> The last 3 changesets do the trick to not oops, it will delay the 
> deinitialization of the device till the last user closed the device node.

Probably dumb question (since I'm not at all familiar with the dvb
code): Isn't that a different race you're solving there? I don't see
any driver core objects involved (except class devices created by
class_device_create, which obviously don't have the release function
problem). This looks more like a race of "we want an object to go
away, but a user still has a file open" (which would be similar to the
kobject<->sysfs lifetime rules issues, where work is currently ongoing).
