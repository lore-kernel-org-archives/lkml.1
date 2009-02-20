Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbZBTAym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbZBTAym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 19:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbZBTAyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 19:54:32 -0500
Received: from web110616.mail.gq1.yahoo.com ([67.195.13.207]:40711 "HELO
	web110616.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752058AbZBTAyb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 19:54:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=DBOz3VJFtZA31oCRhefPcOsmSQF1+0/0wGkGL/KkciNzMGFBgnasu+6QcwAWkk6ZoMjw2dSYSZS0D40XjGsHXxd9QPtXzBEyHUMZSDj2KGyaeqexfGNRyBSQ71qfLwoe490qQjp5mTSc1qHdtUc7QQQ2PRGteSEN9yxvZ/iZp90=;
X-YMail-OSG: dqoJrM0VM1mNKHlOqKz7D6VY9ffqHzNaSDeY.l8he3tb3u3bwWe823fmDPk2GGttpFUdHfhkSHaGuy19.XchEwRHlXipEkCrT0ODBmg8sEvhKChW8DGMQe..9KO97s1b0esEhYSCQCavJyQZVoNKhVzc.iRRWgGAI1jWfa5kacw9_6Dci5tqgu..1QFOIzaQmNb4OiICnh7WSt6ASAaU9nHuoegw7KHIYt4KfVa4shPpSajzMw712RH61y0749mbMvMFgQd1OmlsFg_VMZQglt4otaCBqPU-
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
References: <56979.43325.qm@web110612.mail.gq1.yahoo.com> <1235080134.12500.45.camel@localhost.localdomain>
Date: Thu, 19 Feb 2009 16:54:29 -0800 (PST)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [SCSI][REGRESSION][BISECTED] Disk errors loop forever in 2.6.29
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       rjw@sisk.pl, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <852441.94339.qm@web110616.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: James Bottomley <James.Bottomley@HansenPartnership.com>

> 
> Your specific behaviour change seems to be a bug in the way the rewrite
> is handling ABORTED_COMMAND.  Could you try the patch below (with or
> without the block patch, it shouldn't matter) and see if it gets you
> back to 2.6.28 behaviour?

Yup that patch makes things timeout quickly just like 2.6.28. The whole 
"it didn't used to cache failures" piece in the previous email seems to
have been a fabrication inside my own head - I checked and 2.6.28 caches
the failure until the cache is dropped too.

It might be worth turning your original patch into some sort of warning
stack trace trigger so that people understand it's just there for 
unwedging and isn't expected behaviour (it is useful for breaking out of
near lockups though).

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>



      
