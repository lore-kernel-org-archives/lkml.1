Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZINRHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZINRHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZINRHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:07:19 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41358 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755149AbZINRHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:07:17 -0400
X-Sasl-enc: tG7Dh31p05/FmyBQmyISHW8TZ94+ky3svLEeEVSalcMD 1252948040
Date: Mon, 14 Sep 2009 14:07:17 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Corentin Chary <corentincj@iksaif.net>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/3] rfkill_unregister() should always be followed by
 rfkill_destroy()
Message-ID: <20090914170717.GA13452@khazad-dum.debian.net>
References: <1252925033-29696-1-git-send-email-corentincj@iksaif.net>
 <20090914132401.GC32253@khazad-dum.debian.net>
 <4AAE59CB.8030702@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAE59CB.8030702@tuffmail.co.uk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009, Alan Jenkins wrote:
> Henrique de Moraes Holschuh wrote:
> > On Mon, 14 Sep 2009, Corentin Chary wrote:
> >   
> >>  drivers/platform/x86/dell-laptop.c   |   36 ++++++++++++++++++++++-----------
> >>  drivers/platform/x86/hp-wmi.c        |    2 +-
> >>  drivers/platform/x86/thinkpad_acpi.c |    1 +
> >>     
> >
> > These are also likely needed in 2.6.31, please add appropriate Cc: lines to
> > stable@kernel.org while adding the Acked-By's.
> 
> Do they meet the -stable criteria?

The ones for thinkpad_acpi and hp-wmi do (fix obvious bug, small and
obviously correct, impossible to cause regressions).

I don't know about the fix for dell-laptop since it is a lot larger.

>  - It must fix a real bug that bothers people (not a, "This could be a
>    problem..." type thing).

Memory leaks are real bugs, especially these ones that _always_ happen and
are not even on the error paths, but on the main code path...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
