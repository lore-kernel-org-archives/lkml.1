Return-Path: <linux-kernel-owner+w=401wt.eu-S1762625AbXLNAOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762625AbXLNAOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933490AbXLNAOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:14:19 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:18376 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046AbXLNAOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:14:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=AH/ADN9TNyjiTrbts39NHUTDEhrUxbbW5pxz5eq1t4MQfPkSC3+aEpU3zk7Z1eb98BkH7OCLTXTEH9Dwjfrqarch2hqimLCZml4Gq8TtAFcQMYYXXOjiwGuv2NfXlarfuf1+GpmNVILxRzA+dJhrq6g6aS8RSMGp1XNhrluD0Ug=
Message-ID: <b70f2f960712131614u7515f0fcxf17d9791eb33c5eb@mail.gmail.com>
Date: Fri, 14 Dec 2007 03:14:14 +0300
From: "Mikhail Kshevetskiy" <mikhail.kshevetskiy@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eduard-Gabriel,

You write:

> +	  dynamic ticks to work. It's safe to enable this option even if
> +	  your system doesn't have an AMD CPU (there are no side-effects if
> +	  such a CPU isn't detected).

It's definitely not safe. There are the computers with totally broken
BIOSes, they setup C1e flags  for one core only. If you try to disable
C1e on such machine, you most likely kill the kernel.

>From my point of view, you patch should work in both directions, i.e.
1) user should be allowed to force disable C1e for all cores.
2) user should be allowed to force enable C1e for both cores.

and if the user don't use this flag, the C1e state should be untouched.

Mikhail Kshevetskiy
