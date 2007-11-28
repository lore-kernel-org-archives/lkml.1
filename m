Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbXK1Oq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbXK1Oq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbXK1Oqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:46:51 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:53291 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842AbXK1Oqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:46:51 -0500
Message-ID: <474D7F5B.9090008@lwfinger.net>
Date: Wed, 28 Nov 2007 08:46:51 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding mutex locking
References: <474CF06C.8020208@lwfinger.net> <20071128081031.GF20238@traven>
In-Reply-To: <20071128081031.GF20238@traven>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Kaehlcke wrote:
> El Tue, Nov 27, 2007 at 10:37:00PM -0600 Larry Finger ha dit:
> 
>> If a particular routine needs to lock a mutex, but it may be entered with that mutex already locked,
>> would the following code be SMP safe?
>>
>> hold_lock = mutex_trylock()
>>
>> ...
>>
>> if (hold_lock)
>> 	mutex_unlock()
> 
> this is wont work, a mutex must not be released from another
> context than the one that acquired it.

I thought that mutex_trylock() returned 1 if it got the lock and 0 if not. If that is true, wouldn't
the if statement only unlock if the lock was obtained in this routine?

