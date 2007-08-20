Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbXHTMo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbXHTMo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 08:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbXHTMos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 08:44:48 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55360 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbXHTMos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 08:44:48 -0400
Date: Mon, 20 Aug 2007 14:44:47 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: Andy Whitcroft <apw@shadowen.org>, Eugene Teo <eugeneteo@kernel.sg>,
       linux-kernel@vger.kernel.org, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] Make checkpatch rant about trailing ; at the end of "if"
  expr
In-Reply-To: <E1IN5oB-0000qw-6S@be1.lrz>
Message-ID: <Pine.LNX.4.64.0708201438180.30570@fbirervta.pbzchgretzou.qr>
References: <8SGSb-2Kk-9@gated-at.bofh.it> <8SJQ6-7pj-13@gated-at.bofh.it>
 <8T8Oy-3D0-13@gated-at.bofh.it> <E1IN5oB-0000qw-6S@be1.lrz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-1888346630-1187613887=:30570"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-1888346630-1187613887=:30570
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Aug 20 2007 13:52, Bodo Eggert wrote:
>> But. The above regex does not seem to handle
>> 
>> if ((a = b));
>> oops;
>> 
>> I have tried to come up with a superduper regex that handles multiple
>> (), but my regex fu seems to stop above two pairs of ().
>
>This is because you can't do that using finite regular expressions.
>
>Regular expressions are Type-3 grammars, but you'd need a Type-2
>grammar to express the Dyck language (and you need to parse a Dyck
>Language, ignoring the non-dyck-parts).

So what about this then...


$s = shift @ARGV;
$r = qr/a(??{ $r })?b/;
if ($s =~ /^$r$/) {
	print "Yup, that's good\n";
} else {
	print "fail\n";
}


$ perl foo.pl aabbbb
Not so much
$ perl foo.pl aaaabbbb
Yup, that's good
$ perl foo.pl aaaaabbbb
Not so much


>-- 
>Your e-mail has been returned due to insufficient voltage. 
>
>Friß, Spammer: xVhgayew@6yAk1Uy.7eggert.dyndns.org G2@7eggert.dyndns.org
> MVt59@gcEE.7eggert.dyndns.org GBwox2uHv@mb.7eggert.dyndns.org
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

	Jan
-- 
---699020219-1888346630-1187613887=:30570--
