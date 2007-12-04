Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbXLDHon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbXLDHon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 02:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbXLDHoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 02:44:34 -0500
Received: from ns2.suse.de ([195.135.220.15]:52431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbXLDHod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 02:44:33 -0500
Date: Mon, 3 Dec 2007 23:46:56 -0800
From: Greg KH <gregkh@suse.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: The use of KOBJ_NAME_LEN
Message-ID: <20071204074656.GB25316@suse.de>
References: <20071204064547.GA17094@darkstar.lan> <alpine.LFD.0.9999.0712040150010.31686@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712040150010.31686@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 01:50:53AM -0500, Robert P. J. Day wrote:
> On Tue, 4 Dec 2007, Dave Young wrote:
> 
> > Hi,
> > Does the KOBJ_NAME_LEN really means the limit of kobject name length? seems not . And if it's true, is the KOBJ_NAME_LEN of 20 enough to use?
> >
> > In the kobject_set_name, the limit is 1024. Looks like either the comment or the code should be updated.
> >
> > /**
> >  *      kobject_set_name - Set the name of an object
> >  *      @kobj:  object.
> >  *      @fmt:   format string used to build the name
> >  *
> >  *      If strlen(name) >= KOBJ_NAME_LEN, then use a dynamically allocated
> >  *      string that @kobj->k_name points to. Otherwise, use the static
> >  *      @kobj->name array.
> >  */
> 
> the comment seems fairly clear -- if the name is sufficiently short,
> it's stored in the static array.  if not, then it's stored in
> dynamically allocated space.

Unfortunately, it's totally wrong, the code was updated by the comment
wasn't, sorry.  See my patch to fix this.

thanks,

greg k-h
