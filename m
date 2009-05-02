Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZEBIqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZEBIqF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 04:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZEBIpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 04:45:53 -0400
Received: from mailgw2.hevs.ch ([153.109.6.17]:31732 "EHLO mailgw2.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZEBIpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 04:45:52 -0400
Message-Id: <49FC2455020000BF000290DA@mailgw2.hevs.ch>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Sat, 02 May 2009 10:45:41 +0200
From: "Marc Pignat" <Marc.Pignat@hevs.ch>
To: <marcel@holtmann.org>, <jkosina@suse.cz>
Cc: <ext-roger.quadros@nokia.com>, <linux-bluetooth@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Marcel Holtmann <marcel@holtmann.org> 05/02/09 12:57 AM >>>
>Hi Jiri,
>
>> > Subject: bluetooth: Fix serialization when adding/deleting connections in hci_sysfs
>> > 
>> > add_conn and del_conn should be serialized, but flush_workqueue can't be used
>> > by the worker thread on it's own queue, so use flush_work to serialize add_conn
>> > and del_conn against each other.
>> > 
>> > Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
>> 
>> Acked-by: Jiri Kosina <jkosina@suse.cz>
>> 
>> FWIW.
>
>nak from my side since I think it is the wrong fix. We really wanna wait
>for all works to finish here. This includes work from other connection
>attempts or terminations.

IMHO, there is no need to wait for work currently running, since this is a
singlethread workqueue.

But it is perhaps simpler to use a lock (mutex or watherver locking primitive).

Regards

Marc

