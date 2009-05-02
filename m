Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbZEBRDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbZEBRDo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 13:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbZEBRDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 13:03:35 -0400
Received: from senator.holtmann.net ([87.106.208.187]:54083 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbZEBRDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 13:03:34 -0400
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
From: Marcel Holtmann <marcel@holtmann.org>
To: Marc Pignat <Marc.Pignat@hevs.ch>
Cc: jkosina@suse.cz, ext-roger.quadros@nokia.com,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <49FC2455020000BF000290DA@mailgw2.hevs.ch>
References: <49FC2455020000BF000290DA@mailgw2.hevs.ch>
Content-Type: text/plain
Date: Sat, 02 May 2009 10:03:26 -0700
Message-Id: <1241283806.3156.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

can you please stop breaking the threading here. Your responses are
hanging all over the place and it is hard to keep track of them.

> >> > Subject: bluetooth: Fix serialization when adding/deleting connections in hci_sysfs
> >> > 
> >> > add_conn and del_conn should be serialized, but flush_workqueue can't be used
> >> > by the worker thread on it's own queue, so use flush_work to serialize add_conn
> >> > and del_conn against each other.
> >> > 
> >> > Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
> >> 
> >> Acked-by: Jiri Kosina <jkosina@suse.cz>
> >> 
> >> FWIW.
> >
> >nak from my side since I think it is the wrong fix. We really wanna wait
> >for all works to finish here. This includes work from other connection
> >attempts or terminations.
> 
> IMHO, there is no need to wait for work currently running, since this is a
> singlethread workqueue.
> 
> But it is perhaps simpler to use a lock (mutex or watherver locking primitive).

I think that using a mutex might be a better solution to ensure that
previous work has been finished.

Regards

Marcel


