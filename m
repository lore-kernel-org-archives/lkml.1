Return-Path: <linux-kernel-owner+w=401wt.eu-S1161698AbXDXHoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161698AbXDXHoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161697AbXDXHoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:44:06 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:53847 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161690AbXDXHoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:44:03 -0400
Date: Tue, 24 Apr 2007 09:46:48 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linas Vepstas <linas@austin.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, "<Andrew Morton" <akpm@osdl.org>,
       containers@lists.osdl.org, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc pseries eeh: Convert to kthread API
Message-ID: <20070424094648.43d2b9b4@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1177390842.14873.94.camel@localhost.localdomain>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769695763104-git-send-email-ebiederm@xmission.com>
	<20070422123155.GF20763@infradead.org>
	<20070423205020.GR31947@austin.ibm.com>
	<1177378733.14873.52.camel@localhost.localdomain>
	<m1ejmav80l.fsf@ebiederm.dsl.xmission.com>
	<1177382544.14873.57.camel@localhost.localdomain>
	<m1abwyv4oq.fsf@ebiederm.dsl.xmission.com>
	<1177390842.14873.94.camel@localhost.localdomain>
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

On Tue, 24 Apr 2007 15:00:42 +1000,
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> Like anything else, modules should have separated the entrypoints for
> 
>  - Initiating a removal request
>  - Releasing the module
> 
> The former is use did "rmmod", can unregister things from subsystems,
> etc... (and can file if the driver decides to refuse removal requests
> when it's busy doing things or whatever policy that module wants to
> implement).
> 
> The later is called when all references to the modules have been
> dropped, it's a bit like the kref "release" (and could be implemented as
> one).

That sounds quite similar to the problems we have with kobject
refcounting vs. module unloading. The patchset I posted at
http://marc.info/?l=linux-kernel&m=117679014404994&w=2 exposes the
refcount of the kobject embedded in the module. Maybe the kthread code
could use that reference as well?
