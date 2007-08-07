Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbXHGMJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbXHGMJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbXHGMJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:09:30 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:25044 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbXHGMJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:09:29 -0400
Date: Tue, 7 Aug 2007 14:10:30 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Javier Pello" <javier.pello@urjc.es>, linux-kernel@vger.kernel.org,
       "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not
 notified
Message-ID: <20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <3ae72650708070446y6452d13jb7cd802119dab3ce@mail.gmail.com>
References: <46B37CF7.2020803@urjc.es>
	<20070806142451.5d28d41c@gondolin.boeblingen.de.ibm.com>
	<46B7832B.6010808@urjc.es>
	<20070807125844.4d756b04@gondolin.boeblingen.de.ibm.com>
	<3ae72650708070446y6452d13jb7cd802119dab3ce@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2007 13:46:55 +0200,
"Kay Sievers" <kay.sievers@vrfy.org> wrote:

> > - Use an extra parameter in which successful delivery can be indicated.
> > Make this
> > int kobject_uevent_env_check(struct kobject *kobject,
> >                              enum kobject_action action,
> >                              char *envp[], int delivered);
> > so existing callers that don't care don't have to be changed.
> 
> How do you check if events have been "handled"? None of the recent
> distros uses /sbin/hotplug anymore. Netlink events are broadcasted,
> but no failure in delivery doesn't mean anything like "handled", or
> delivered to the right instance. Even if you check that the netlink
> socket has listeners, that wouldn't be sufficient to tell that is is
> handled.

You can't check if it's been handled, yes; but you can certainly check
if you delivered it. I guess Javier wants to exclude the cases where
userspace didn't have any chance to handle it.

Javier: Do you have an idea how common the case "we broadcasted, but
nobody listened so we got a timeout" is? If the usual reason for the
timeout is that firmware was requested before a listener showed up, I'm
not sure whether that check is worth it...
