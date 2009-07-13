Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZGMKJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZGMKJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 06:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbZGMKJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 06:09:10 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:46154 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265AbZGMKJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 06:09:09 -0400
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2009 06:09:09 EDT
Date: Mon, 13 Jul 2009 13:00:35 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: linux-kernel@vger.kernel.org
Subject: New List Manager experiment at vger.kernel.org
Message-ID: <20090713100035.GI10130@mea-ext.zmailer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am doing some experimenting of a new list manager concept for vger.

If things go well, it will replace Majordomo,  and the command interface
will be similar to Majordomo -- including eventual address where it
responds:  majordomo@vger ...

Right now the thing is available for the curious at:

   listmanager@vger.kernel.org


The main difference in here against the Majordomo, and even Mailman is
that this system uses SQL database to keep track of lists, subscribers,
and subscriptions.  Not individual text (or horrors - object serialization
binary streams!) files.


Supported commands:

   lists
   which
   subscribe listname
   unsubscribe listname
   unsubscribe *
   auth ...

They are similar, and yet slightly different from Majordomo's commands.
For example the authentication token is unique random blob, which has
meaning only for given user trying to subscribe OR UNSUBSCRIBE, and one
can not predict its value, thus malicious removal on somebodys subscriptions
is at least difficult.

The "help" command will be replaced with a web-page describing the commands.


At present the system is in development mode, and no email traffic goes
thru it.  However it has utility to import all existing VGER's Majordomo
list configurations, and subscribers, which utility I do run quite often
to prime databases - especially after altering database schemas.

The 'lists' command shows all public list email addresses, and how many
'direct delivery' subscribers there are.

The 'subscribe' command adds email address, and subscription data in state
'unconfirmed', and calls for confirmation.

Doing then 'auth' commands in shown way will change state to
value 'direct'.  Somewhere in deep plans is to add also 'digest',
but we shall see...

The 'unsubscribe *' will send a list of "please send these
'auth ... unsubscribe NNN' commands back to me, if you approve."

The 'which' is best explained by an example:

# << which
# List of subscriptions for this address:
#    linux-kernel@vger.kernel.org             (direct)
#    netdev@vger.kernel.org                   (unconfirmed)
#    netfilter@vger.kernel.org                (unconfirmed)

Doing a set of 'subscribe' commands followed by 'which' command will
show you something like this above example has.  The 'linux-kernel'
subscription has been confirmed with 'auth' command, thus its state
is 'direct', others are still pending.


Somebody will want to know if the sources will be available.
Yes, but it is only my 3rd day of hacking at it yet...

/Matti Aarnio -- one of  <postmaster@vger.kernel.org>
