Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbXIMOzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbXIMOzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXIMOzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:55:48 -0400
Received: from ns.firmix.at ([62.141.48.66]:34117 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbXIMOzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:55:47 -0400
Subject: Re: [PATCH] 9p: rename uid and gid parameters
From: Bernd Petrovitsch <bernd@firmix.at>
To: Latchesar Ionkov <lucho@ionkov.net>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org
In-Reply-To: <f158dc670709130751s2f6046beje5401ec6c56051dd@mail.gmail.com>
References: <20070913044718.GB2675@ionkov.net>
	 <a4e6962a0709130638v384c2708y76167d4e92cbac56@mail.gmail.com>
	 <f158dc670709130751s2f6046beje5401ec6c56051dd@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Thu, 13 Sep 2007 16:55:30 +0200
Message-Id: <1189695330.9137.75.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.315 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.315 required=5
X-Spam-Score: -2.315 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 08:51 -0600, Latchesar Ionkov wrote:
> Zero was the value that was used before, even though it wasn't defined
> explicitly. I just defined a macro so we can see and eventually change
> it to something better. I don't know if there is a good default value.
> Is nfsnobody the same on all Linux distributions?

Not necessarily.

[....]
> On 9/13/07, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> > On 9/12/07, Latchesar Ionkov <lucho@ionkov.net> wrote:
> > > Change the names of 'uid' and 'gid' parameters to the more appropriate
> > > 'dfltuid' and 'dfltgid'.
> > >
> >
> > ...
> >
> > >         strcpy(v9ses->name, V9FS_DEFUSER);
> > >         strcpy(v9ses->remotename, V9FS_DEFANAME);
> > > +       v9ses->dfltuid = V9FS_DEFUID;
> > > +       v9ses->dfltgid = V9FS_DEFGID;
> > >
> > ...
> > > +#define V9FS_DEFUID    (0)
> > > +#define V9FS_DEFGID    (0)
> >
> > I'm not sure if there is a good solution here, but I'm uncomfortable
> > with using uid=0 as the default.  I'm not sure if there is a default
> > uid for nobody, but anything is probably better than 0.  Looks like
> > nfsnobody is 65534, we could use that - even if only as a marker for

On 32bit hardware. On 64bit it is (similar to 32bit): (unsigned int)-2.

> > the server to map it to nobody on the target system?  What do you
> > think?
> >
> > Particularly with attach-per-user, we probably need to look at
> > interacting with idmapd or create our own variant real soon.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


