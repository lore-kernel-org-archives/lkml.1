Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbXK1Exh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbXK1Exh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 23:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbXK1Ex1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 23:53:27 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:62109 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbXK1Ex0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 23:53:26 -0500
Date: Tue, 27 Nov 2007 22:53:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Question regarding mutex locking
In-reply-to: <fa.C9TdvYAhY8SablNc39IpD8WDnNM@ifi.uio.no>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <474CF440.2000001@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.C9TdvYAhY8SablNc39IpD8WDnNM@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> If a particular routine needs to lock a mutex, but it may be entered with that mutex already locked,
> would the following code be SMP safe?
> 
> hold_lock = mutex_trylock()
> 
> ..
> 
> if (hold_lock)
> 	mutex_unlock()

Not if another task could be acquiring that lock at the same time, which 
is probably the case, otherwise you wouldn't need the mutex. In other 
words, if you're going to do this, you might as well toss the mutex 
entirely as it's about the same effect..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

