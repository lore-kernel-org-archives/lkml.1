Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbXEGO4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbXEGO4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbXEGOz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:55:58 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:44546 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbXEGOz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:55:57 -0400
Date: Mon, 7 May 2007 17:55:55 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: linux-kernel@vger.kernel.org
Subject: gmail is a bit too popular..
Message-ID: <20070507145555.GG3883@mea-ext.zmailer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the  linux-kernel  -list subscribers domain popularity
analysis I got following results:

   2101 gmail.com
     49 googlemail.com
     46 gmx.de
     41 redhat.com
     33 yahoo.com
     23 suse.de
     22 gmx.net
     21 comcast.net


The  gmail  is so popular, that with their somewhat rudimentary 
inbound MTA software this kind of recipient masses take horrible
time to feed in...  Mere 0.5-0.7 seconds per recipient, but..

So far we have tried to feed all recipients in one go per
message - that is sending 2100  RCPT TO -lines in one swoop,
and the system has taken some 15-25 minutes per message to
feed it to gmail.  We are running the delivery 20 streams in
parallel, so it isn't quite as bad as it sounds..

I do have one thing that gmail could enable to speed up the message
delivery (a lot!) from VGER and other list delivery sources.
That single magic needed thing is called "PIPELINING" support
at gmail's inbound MX servers.  With suitably well behaving
smtpserver it is really trivial to implement, all real difficult
magic is at the sending side smtp client codes.

Once upon a time I implemented that thing for a trans-atlantic
SMTP fanout feed -- message delivery time became slashed from
hundreds of RTT delays to mere few..

  /Matti Aarnio
