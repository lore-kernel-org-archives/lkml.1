Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbXISXo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbXISXo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbXISXov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:44:51 -0400
Received: from smtp112.sbc.mail.re2.yahoo.com ([68.142.229.93]:22073 "HELO
	smtp112.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750717AbXISXou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:44:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=I3ivLc6RwhdvvfoG8Xp9qPubn7U60gcEb05dPRcQ12ndoR8HJYhtqSUI3MwJFPXslCF4AMky63n6gzjByi7TSpWTC2cJlAsqO19wqNd7oQ71vYRhPtO6cYB/a05JBRr69dxSWDSyDtUF8Fl4JboZjkdOyodTlKhMIUTVV9o6eSY=  ;
X-YMail-OSG: R.Qc1foVM1kFXlNzzQOvDMur0efaY.2EJC2wp8T2ec3KWXuMz8IjAvamRdcsCLjxdcS3RR45oZ3.pnNBkSK7r7rq_zt9w.9eB3nia01e4l3IuuE2JZOOdwlgI7nXdCdewBzhE9ZKXipiQg--
Date: Wed, 19 Sep 2007 16:44:48 -0700
From: David Brownell <david-b@pacbell.net>
To: Chuck Ebbert <cebbert@redhat.com>, tilman@imap.cc,
       akpm@linux-foundation.org
Subject: Re: 2.6.23-rc6-mm1
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, a.zummo@towertech.it
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
 <46F1AA6E.1030708@imap.cc>
 <20070919162438.7264f06c.akpm@linux-foundation.org>
In-Reply-To: <20070919162438.7264f06c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070919234448.8E87D2319AA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton <akpm@linux-foundation.org>

> > <4>[   21.211942] Duplicate file names "rtc" detected
>
> Nah, that's an rtc-specific problem.

RTC-related ... but it's a procfs bug, since it's procfs which doesn't
even bother to check for duplicate names before it registers files.
And it's that duplication which is the problem.  Try the patch in
this message

  http://lkml.org/lkml/2007/9/19/18


> I think David says that it's actually not a problem, but I didn't
> really understand how this can be?

I said it's not an RTC problem ... it's a procfs problem.

Trying to fix procfs bugs by changing RTC code is futile.  ;)


> From: Chuck Ebbert <cebbert@redhat.com>
>
> AFAICT the rtc problem is caused by misconfiguration: both the new
> and old rtc driver have been built and they are both trying to load.

That _shouldn't_ be a problem at all; only one of them should be
able to bind to that hardware.

The only problem I see in these messages is that procfs bug.

- Dave

