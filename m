Return-Path: <linux-kernel-owner+w=401wt.eu-S1763635AbYEGUsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763635AbYEGUsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbYEGUsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:48:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42835 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbYEGUsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:48:43 -0400
Date: Wed, 7 May 2008 22:48:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Xavier Bestel <xavier.bestel@free.fr>
cc: Morten Welinder <mwelinder@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Deleting large files
In-Reply-To: <1210191456.14754.1.camel@bip.parateam.prv>
Message-ID: <alpine.LNX.1.10.0805072247510.30395@fbirervta.pbzchgretzou.qr>
References: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>  <alpine.LNX.1.10.0805072208140.30395@fbirervta.pbzchgretzou.qr> <1210191456.14754.1.camel@bip.parateam.prv>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-05-07 22:17, Xavier Bestel wrote:
>Le mercredi 07 mai 2008 à 22:10 +0200, Jan Engelhardt a écrit :
>> 
>> >I.e., could unlink do the directory changes and then hand off the rest of the
>> >task to a kernel thread?
>> 
>> Say you had one realtime application running that would do lots of new
>> writes after the unlink finished. When the unlink is put into the
>> background, you interleave the unlink operation with new writes,
>> probably causing needless seeks and therefore not hitting the deadlines
>> anymore.
>
>Why ? The writes are delayed, so could be the unlink operations.

Code complexity. But then again, a few good filesystems
don't even need to do such heavy housekeeping, and I
suggest using these if you are worried about unlink speed.
