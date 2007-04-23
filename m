Return-Path: <linux-kernel-owner+w=401wt.eu-S1030970AbXDWFjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030970AbXDWFjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 01:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030980AbXDWFjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 01:39:13 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:41996
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030970AbXDWFjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 01:39:13 -0400
Date: Mon, 23 Apr 2007 07:42:14 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: emoenke@gwdg.de, minyard@wf-rch.cirr.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use spinlock instead of binary mutex in CDU-31A driver
Message-ID: <20070423054213.GQ5013@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Andi Kleen <andi@firstfloor.org>, emoenke@gwdg.de,
	minyard@wf-rch.cirr.com, linux-kernel@vger.kernel.org
References: <20070422213531.GO5013@traven> <p737is43sah.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p737is43sah.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, Apr 23, 2007 at 01:25:58AM +0200 Andi Kleen ha dit:

> Matthias Kaehlcke <matthias.kaehlcke@gmail.com> writes:
> 
> > -static DECLARE_MUTEX(sony_sem);		/* Semaphore for drive hardware access */
> > +static DEFINE_MUTEX(sony_mtx);		/* Mutex for drive hardware access */
> 
> That's not a spinlock.  Also normally some rationale is added to the
> description for a change?

sorry i messed up the description of the change, i meant mutex instead
of spinlock (in the last days i reported some spinlock related bugs
...). 

the rationale is that according to http://lwn.net/Articles/167034/
binary semaphores that aren't given in interrupt context or
locked and unlocked by different processes should be replaced by
mutexes

thanks for your comments

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

              La posibilidad de realizar un suenyo es lo
                 que hace que la vida sea interesante
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
