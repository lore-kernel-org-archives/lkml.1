Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbYCEM3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbYCEM3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762171AbYCEM3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:29:10 -0500
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:51890 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757442AbYCEM3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:29:03 -0500
Message-ID: <47CE8E68.5060701@knosof.co.uk>
Date: Wed, 05 Mar 2008 12:13:28 +0000
From: Derek M Jones <derek@knosof.co.uk>
Organization: Knowledge Software, Ltd
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Christopher Li <sparse@chrisli.org>, Julia Lawall <julia@diku.dk>,
       yi.zhu@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Alexander Viro <viro@ftp.linux.org.uk>,
       linux-sparse@vger.kernel.org, Josh Triplett <josh@freedesktop.org>
Subject: Re: [PATCH 6/9] drivers/net/wireless/iwlwifi/iwl-4965.c: Correct
 use of ! and &
References: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk> <20080305063842.GA24495@elte.hu> <70318cbf0803042249j57d7f3a3j7666961a9132b10b@mail.gmail.com> <20080305070201.GA32434@elte.hu> <1204700995.17484.7.camel@brick> <20080305081904.GA17789@elte.hu>
In-Reply-To: <20080305081904.GA17789@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

>>> i think there might be similar patterns: "x & !y", "!x | y", "x | !y" ?
>>>
>> Well, (!x & y) and (!x | y) are probably the two that might have been 
>> intended otherwise.  (x & !y), (x | !y) are probably ok.
> 
> i think the proper intention in the latter cases is (x & ~y) and
> (x | ~y).
> 
> My strong bet is that in 99% of the cases they are real bugs and && or 
> || was intended.

Developer knowledge of operator precedence and the issue of what
they intended to write are interesting topics.  Some experimental
work is described in (binary operators only I'm afraid):

www.knosof.co.uk/cbook/accu06a.pdf
www.knosof.co.uk/cbook/accu07a.pdf

The ACCU 2006 experiment provides evidence that developer knowledge
is proportional to the number of occurrences of a construct in
source code, it also shows a stunningly high percentage of incorrect
answers.

The ACCU 2007 experiment provides evidence that the names of the
operands has a significant impact on operator precedence choice.

I wonder what kind of names are used as the operand of unary
operators?

I would expect the ~ operator to have a bitwise name, but the
! operator might have an arithmetic or bitwise name.

-- 
Derek M. Jones                              tel: +44 (0) 1252 520 667
Knowledge Software Ltd                      mailto:derek@knosof.co.uk
Applications Standards Conformance Testing    http://www.knosof.co.uk
