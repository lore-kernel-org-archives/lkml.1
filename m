Return-Path: <linux-kernel-owner+w=401wt.eu-S1751298AbXCLSZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbXCLSZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXCLSZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:25:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:37586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbXCLSZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:25:08 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Date: Mon, 12 Mar 2007 19:25:00 +0100
User-Agent: KMail/1.9.1
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0703121216210.2489-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0703121216210.2489-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703121925.01771.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. März 2007 17:21 schrieb Alan Stern:
> On Mon, 12 Mar 2007, Oliver Neukum wrote:
> 
> > > > Yes, I was missing the point. In consequence, drivers must not use
> > > > dev_get_drvdata() to get their references to their private data. It's
> 
> You do realize how foolish that sounds?  Why do you think 
> dev_get_drvdata() was written in the first place?

It's still useful in disconnect/suspend/resume/etc...
If everything were alright with the design, we wouldn't be discussing
it now, would we?

 
> I'm with Dmitry; the whole thing becomes much, much simpler if we put back
> your patch and prevent sysfs access after unregistering an attribute 
> file.  No API changes are needed, no driver changes are needed, no radical 
> core changes are needed,...  All we would have to do is fix the one SCSI 
> method to make it use a workqueue.

Try. I don't like reverting my own code. But I predict he'll tell you that a
driver's bond with a device should be represented in a data structure
that is to be refcounted.

	Regards
		Oliver
