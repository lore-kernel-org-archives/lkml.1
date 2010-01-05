Return-Path: <linux-kernel-owner+w=401wt.eu-S932194Ab0AEV1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab0AEV1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464Ab0AEV1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:27:09 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43984 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab0AEV1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:27:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=ClEIzl7rQNfZObRXFKr/vrNddZcXtPmdW9ZnBuBC6X1HVSNczoleHK/d3Qcmn45DUB
         USt2e326hUx129cJ+nq3YR946CaVNSYxxTGvc/67g6L2h2EX/fymdnCbYJH7Thtqf0+6
         pja4IxRXKe02IUYIYFdmeoWcjKijfo0XSAjrQ=
Date: Tue, 5 Jan 2010 22:26:57 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?UTF-8?B?QmFydMWCb21pZWogWmltb8WE?= <uzi18@o2.pl>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       danborkmann@googlemail.com, awalls@radix.net
Subject: Re: [linux-pm] [suspend/resume] Re: userspace notification from
 module
Message-ID: <20100105222657.27218c4c@strolchi.home.s3e.de>
In-Reply-To: <20100105090706.751D233C4B0@tippex.mynet.homeunix.org>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl>
	<201001040045.39517.rjw@sisk.pl>
	<a522f3c.3bab16d1.4b413b9c.ec43@o2.pl>
	<201001042043.27037.rjw@sisk.pl>
	<20100105090706.751D233C4B0@tippex.mynet.homeunix.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.19.2; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jan 2010 10:07:06 +0100
Anders Eriksson <aeriksson@fastmail.fm> wrote:

> 
> rjw@sisk.pl said:
> >> > I don't see a problem with this in principle, although I don't think signals
> >> > are very suitable for this particular purpose, because you need two-way
> >> > communication between the power manager and the processes it's going to
> >> > notify (because it has to wait for the processes to finish their preparations
> >> > and to tell it that they are ready). 
> 
> Wouldn't there need to be dependecy tracking for the userspace processes? A 
> process couldn't signal "done" until it know there's no more work to do, which 
> requires all other processes to finish up first.

No. 99% of the processes don't care about suspend. They don't need
notifications or anything.
The few that do care, register themselves with the power manager. They
get notified before suspend and the power manager might wait until they
tell him that they are ready.
A special case are processes that only want to inhibit suspend - the CD
burning application case - they just tell the power manager "I am
important and you must not suspend now". They do this even if there is
no suspend notification, and once they are done with the critical part
of their work, they remove their "inhibit flag".

This all works pretty well already, and is really not very complicated.
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
