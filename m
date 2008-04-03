Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbYDCXuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbYDCXuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYDCXup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:50:45 -0400
Received: from outbound-mail-124.bluehost.com ([67.222.38.24]:35668 "HELO
	outbound-mail-124.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754784AbYDCXuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:50:44 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: benh@kernel.crashing.org
Subject: Re: [RFC][PATCH 1/3] use new pm_ops in DRM drivers
Date: Thu, 3 Apr 2008 16:48:59 -0700
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Dave Airlie <airlied@linux.ie>
References: <200804020207.40278.rjw@sisk.pl> <200804031150.55967.jbarnes@virtuousgeek.org> <1207259267.10388.334.camel@pasglop>
In-Reply-To: <1207259267.10388.334.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804031648.59630.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 03, 2008 2:47 pm Benjamin Herrenschmidt wrote:
> On Thu, 2008-04-03 at 11:50 -0700, Jesse Barnes wrote:
> > +static struct pm_ops i915_pm_ops = {
> > +       .prepare = NULL, /* DRM core should prevent any new ioctls? */
> > +       .complete = NULL, /* required to re-enable DRM client requests
> > */
>
> The DRM core could definitely provide generic prepare & complete that
> sync'up with user space, making sure the command streams stop etc...

Yeah, that's what I had in mind.  I'll have to think a little harder about it 
though, I think there may be some driver specific stuff required here as 
well, which would mean a driver routine that calls into a core routine (both 
of which still need to be written :).

Jesse
