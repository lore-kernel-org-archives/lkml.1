Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYG1DEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYG1DEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 23:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYG1DEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 23:04:43 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39158 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbYG1DEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 23:04:42 -0400
X-Sasl-enc: Nq7o5cDgoO/IE0+JRGLYWR0i2VXpCnRMBJl4jMVo79qZ 1217214280
Date: Mon, 28 Jul 2008 00:04:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Philip Langdale <philipl@overt.org>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, toshiba_acpi@memebeam.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
	through rfkill
Message-ID: <20080728030437.GC10672@khazad-dum.debian.net>
References: <488CBBAB.6010508@overt.org> <200807272259.44364.IvDoorn@gmail.com> <488CF6D8.6000700@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488CF6D8.6000700@overt.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jul 2008, Philip Langdale wrote:
> Ivo van Doorn wrote:
>>
>> You don't seem to be using rfkill_force_state() which is required to inform the rfkill
>> layer about the state changes.
>
> Hmm? According to rfkill.txt, one can either use force_state() or implement the
> get_state() hook, and I have done the later. If this is not the correct method,
> can you please explain when I should be using force_state?

There is a bunch of rfkill bug fix patches that was not merged in
wireless-testing yet (which is a pity, it would be really good if they could
go into 2.6.27).  One of those patches fixes the docs to make it clear that
rfkill_force_state() is the way to go if you have events of any sort.

The big difference from get_state() is that rfkill_force_state() propagates
state changes as soon as your driver notices them and sends them to rfkill
through rfkill_force_state()... while get_state() can only do that when
someone asks rfkill about the current state.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
