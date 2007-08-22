Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbXHVJWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbXHVJWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXHVJWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:22:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:54659 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXHVJWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:22:36 -0400
Date: Wed, 22 Aug 2007 11:21:48 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Bodo Eggert <7eggert@gmx.de>, Andy Whitcroft <apw@shadowen.org>,
       Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH] Make checkpatch rant about trailing ; at the end of "if"
  expr
In-Reply-To: <Pine.LNX.4.64.0708201438180.30570@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.58.0708221026500.2539@be1.lrz>
References: <8SGSb-2Kk-9@gated-at.bofh.it> <8SJQ6-7pj-13@gated-at.bofh.it>
 <8T8Oy-3D0-13@gated-at.bofh.it> <E1IN5oB-0000qw-6S@be1.lrz>
 <Pine.LNX.4.64.0708201438180.30570@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19vyZX+4JCrm0AeFFl2py7/lPLmf5/EybKW9wy
 gDN1Dj0r6GIYd9oMbDxS6xtVy55+b2+jlji8Wd6m7mEn7V8Nyk
 Z8qapRDcxeyEIdglargZw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007, Jan Engelhardt wrote:
> On Aug 20 2007 13:52, Bodo Eggert wrote:

> >> But. The above regex does not seem to handle
> >> 
> >> if ((a = b));
> >> oops;
> >> 
> >> I have tried to come up with a superduper regex that handles multiple
> >> (), but my regex fu seems to stop above two pairs of ().
> >
> >This is because you can't do that using finite regular expressions.
> >
> >Regular expressions are Type-3 grammars, but you'd need a Type-2
> >grammar to express the Dyck language (and you need to parse a Dyck
> >Language, ignoring the non-dyck-parts).
> 
> So what about this then...
> 
> 
> $s = shift @ARGV;
> $r = qr/a(??{ $r })?b/;

This is not a regular expression, because it can't be parsed by a
finite state machine (DFA/NFA) without a stack.
http://en.wikipedia.org/wiki/Deterministic_finite_state_machine

Obviously perl does allow non-regular expressions.

> if ($s =~ /^$r$/) {
> 	print "Yup, that's good\n";
> } else {
> 	print "fail\n";
> }
> 
> 
> $ perl foo.pl aabbbb
> Not so much
> $ perl foo.pl aaaabbbb
> Yup, that's good
> $ perl foo.pl aaaaabbbb
> Not so much

perl foo.pl aaababbb
fail

"$r = qr/a(??{ $r })?b(??{ $r })?/;" does seem to work.
-- 
"Those who would give up essential liberty, to purchase a little
temporary safety, deserve neither liberty nor safety."
	-- Benjamin Franklin, Historical Review of Pennsylvania, 1759
