Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbZFCQOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbZFCQOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZFCQOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:14:40 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:34635 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbZFCQOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:14:39 -0400
X-Greylist: delayed 1612 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 12:14:38 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nVNQZfMpjQEkaY5Zrrnc35OEvjm/AI3PnSQN9gH7JgYwj2frSPfZy5cj3+OGdxH/1H
         v43T5Gac/ltxXov5GiZOqPDITEJiQGxQaocTchjrkYFkcWE8oCLCcpW5M5jiL5gK3/Hl
         1VUh9eDKQxpJpBy5Xl49VIatLM74qS5n0IJ5k=
MIME-Version: 1.0
In-Reply-To: <1244042950.4862.10.camel@johannes.local>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au> 
	<4A269539.8020607@oracle.com> <1244042950.4862.10.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 3 Jun 2009 17:47:26 +0200
Message-ID: <69e28c910906030847k7e6f97bbo16497d872b93151b@mail.gmail.com>
Subject: Re: linux-next: Tree for June 3 (rfkill)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 5:29 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2009-06-03 at 08:22 -0700, Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>
>> CFG80211=y
>> MAC80211=y
>> RFKILL=m
>>
>> net/built-in.o: In function `cfg80211_netdev_notifier_call':
>> core.c:(.text+0xa678b): undefined reference to `rfkill_blocked'
>> net/built-in.o: In function `cfg80211_dev_free':
>
> Hrm. I thought
>
> config CFG80211
>        tristate "Improved wireless configuration API"
>        depends on RFKILL || !RFKILL
>
> would avoid that. Why doesn't it?
>
> johannes
>

Maybe the "y" state of CFG80211 specifically needs to depend on
RFKILL=y || !RFKILL.

BTW should CFG80211=y really be blocked when RFKILL=m? Shouldn't we
just disable CFG80211 RFKILL support in this case (perhaps via a
separate CONFIG_CFG80211_RFKILL automatically configured depending on
CONFIG_RFKILL)?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
