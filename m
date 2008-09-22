Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYIVVkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYIVVkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYIVVk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:40:28 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:25284 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYIVVk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:40:28 -0400
Date: Mon, 22 Sep 2008 15:40:25 -0600
From: Alex Chiang <achiang@hp.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v2 02/13] PCI: prevent duplicate slot names
Message-ID: <20080922214025.GE3035@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
	kristen.c.accardi@intel.com, matthew@wil.cx,
	kaneshige.kenji@jp.fujitsu.com
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100012.29542.62582.stgit@bob.kio> <200809101658.14823.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809101658.14823.eike-kernel@sf-tec.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rolf Eike Beer <eike-kernel@sf-tec.de>:
> > +
> > +	/*
> > +	 * We hit this the first time through, which gives us
> > +	 * space for terminating NULL, and then every power of 10
> > +	 * afterwards, which gives us space to add another digit
> > +	 * to "name-XX..."
> > +	 */
> > +	if (dup % width == 0) {
> > +		len++;
> > +		width *= 10;
> > +	}
> > +
> > +	new_name = krealloc(new_name, len, GFP_KERNEL);
> > +	if (!new_name)
> > +		goto out;
> 
> If krealloc() fails you will leak the old new_name here.

Thanks for catching this. I already responded to Willy that I'm
changing it to:

	kfree(new_name);
	new_name = kmalloc(len, GFP_KERNEL);

That will prevent any leaks.

Thanks for the review.

/ac

