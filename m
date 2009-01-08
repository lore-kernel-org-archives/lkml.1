Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbZAHBPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbZAHBPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 20:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZAHBPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 20:15:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:51868 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZAHBPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 20:15:47 -0500
Date: Wed, 7 Jan 2009 17:17:45 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/7] async: Asynchronous function calls to speed up
 kernel boot
Message-ID: <20090107171745.3a825edc@infradead.org>
In-Reply-To: <20090108003141.GN23891@ghostprotocols.net>
References: <20090107151151.458333c1@infradead.org>
	<20090107151226.58264d07@infradead.org>
	<20090108003141.GN23891@ghostprotocols.net>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009 22:31:41 -0200
Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Small nitpick:
> 
> - > +		return entry->cookie;
> > +	} else if (!list_empty(running)) {
> > +		entry = list_first_entry(running,
> > +			struct async_entry, list);
> - > +		return entry->cookie;
> > +	} else {
> > +		/* nothing in progress... next_cookie is
> > "infinity" */
> > +		return next_cookie;
> > +	}
> 
> + 	return entry->cookie;

no you cannot do this; entry can be freed by this time already from a
thread.
