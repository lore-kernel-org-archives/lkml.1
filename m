Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbYE0Oys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbYE0Oys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbYE0OyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:54:17 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:37873 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737AbYE0OyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:54:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=doOrPWFNV+CaOLgP1DozJ70ZhAIjMSHBtgceBeUigCRzyrtdyts4m7ESPHQ9ILvLDDNEQTUNtCTwYIUyEpe7ai7JT6AkM5cxx+et3R+rINyQun9dqAA0hxAzrHvdFQaBrB3dYNoQlVCJsSXf7mHl7Sfi7v0SH6HhoQOHJgVYxfM=
Message-ID: <63386a3d0805270754w7144799dn1de33774d852d6d5@mail.gmail.com>
Date: Tue, 27 May 2008 16:54:12 +0200
From: "Linus Walleij" <linus.ml.walleij@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Shifts for clocksources and clockevents
In-Reply-To: <63386a3d0804090104h59fd6633x41a981eb8a1919ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <63386a3d0804090104h59fd6633x41a981eb8a1919ce@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I asked this on the ARM Linux mailing list a while back, but
it appears noone there really has a clue. (Or they didn't see
it.)

Can someone give me a rationale behind the values assigned to
the .shift field in clock_event_device and clocksource in the current
ARM platforms?

When I read the documentation in Documentation/hrtimers/highres.txt
it points me to the PDF
http://www.linuxsymposium.org/2006/linuxsymposium_procv1.pdf
from which I get the impression that shift shall be assigned so
that

(time in ns for 1 cycle)
--------------------------     = 1
           shift
         2

So for a timer running cycles at 1MHz shift would be something like
10 so that 1000/1024 ~= 1.

However the current assignments doesn't look like that at all. I get
the impression that .shift for clock_event_device seem to be set
to 32 at all times in order to blow 32bit counters up to 64 bit,
and clocksource .shift is set to something like 18, 20 or 24 for
unclear reasons.

Any hints here?

Yours,
Linus Walleij
