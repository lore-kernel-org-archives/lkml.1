Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbXHVJ5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbXHVJ5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXHVJ50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:57:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60243 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXHVJ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:57:25 -0400
Date: Wed, 22 Aug 2007 11:57:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: Andy Whitcroft <apw@shadowen.org>, Eugene Teo <eugeneteo@kernel.sg>,
       linux-kernel@vger.kernel.org, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] Make checkpatch rant about trailing ; at the end of "if"
  expr
In-Reply-To: <Pine.LNX.4.58.0708221026500.2539@be1.lrz>
Message-ID: <Pine.LNX.4.64.0708221156330.20435@fbirervta.pbzchgretzou.qr>
References: <8SGSb-2Kk-9@gated-at.bofh.it> <8SJQ6-7pj-13@gated-at.bofh.it>
 <8T8Oy-3D0-13@gated-at.bofh.it> <E1IN5oB-0000qw-6S@be1.lrz>
 <Pine.LNX.4.64.0708201438180.30570@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.58.0708221026500.2539@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 22 2007 11:21, Bodo Eggert wrote:
>
>> >> But. The above regex does not seem to handle
>> >> 
>> >> if ((a = b));
>> >> oops;
>> >> 
>> >> I have tried to come up with a superduper regex that handles multiple
>> >> (), but my regex fu seems to stop above two pairs of ().
>> >
>> >This is because you can't do that using finite regular expressions.
>> >
>> >Regular expressions are Type-3 grammars, but you'd need a Type-2
>> >grammar to express the Dyck language (and you need to parse a Dyck
>> >Language, ignoring the non-dyck-parts).
>> 
>> So what about this then...
>> 
>> $s = shift @ARGV;
>> $r = qr/a(??{ $r })?b/;
>
>This is not a regular expression, because it can't be parsed by a
>finite state machine (DFA/NFA) without a stack.
>http://en.wikipedia.org/wiki/Deterministic_finite_state_machine
>
>Obviously perl does allow non-regular expressions.

Exactly, and which is why my idea was to use a (??{ }) block to match if((()));
but for some reason, it did not fly, and I do not know either why.


	Jan
-- 
