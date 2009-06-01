Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbZFATm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbZFATm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZFATmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:42:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:21497 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbZFATmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=bOGeBuQApGGKkGFahzOAVWuLiLRftiMCjvqlwxmjLNu/DVG6ZMmnX1Ib2dDYYurMID
         Oh0X8H9qKg/IkTRaLFBVKryKZvZS7POiGYmr9XR5h530CdNn1CJM2ypU8+hf4r8i7zCL
         XsHkp/IdgTgBJIQBTDqmLjLAVcNirZof0AxWU=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Jun 2009 12:41:58 -0700
Message-ID: <43e72e890906011241u24b82cc3gc06bf7be4f43075e@mail.gmail.com>
Subject: EXPORT_SYMBOL_GPL recursive for shim and/or wrappers
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Pavel Roskin <proski@gnu.org>, Aaditya.Rai@atheros.com,
       Prem.Kumar@atheros.com, Stephen.Chen@atheros.com,
       Rahul.Sridhar@atheros.com, Allen.Tsai@atheros.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intention behind EXPORT_SYMBOL_GPL seems clear to me -- prevent
proprietary drivers from using GPL-only symbols. Something that to me
is clear but perhaps not to others is the the extent to which this
reaches for proprietary modules. As I interpret it proprietary modules
could _not_ make use of wrappers or shims which export new symbols
with EXPORT_SYMBOL but that those modules were themselves using
EXPORT_SYMBOL_GPL. That is create non-gpl-compatible wrapper symbols
for GPL-compatible-only symbols.

There is a cases though where the intent behind "shim" or "wrappers"
may actually not be to circumvent the GPL-compatible requirement of
code built using EXPORT_SYMBOL_GPL and although I believe it would
still constitute a violation I'd like feedback or more clarity on this
from others. The case would be where the "shim" or "wrapper" provides
realistic APIs for a framework of abstraction for different buses. In
that case the bus-agnostic API layer does make use of
EXPORT_SYMBOL_GPL for USB for example but may not make use of it for
other buses. In any case the intent here would then not to circumvent
the GPL-compatible requirement but to simply implement a bus-agnostic
API.

Does EXPORT_SYMBOL_GPL imply that modules which make use of these
symbols must also use EXPORT_SYMBOL_GPL for their own symbols? If so
then it would be clear of the recursive nature of intent.

To me the recursive nature is clear, but just wanted to ask. I also
don't see this documented in Documentation/ or in the header files,
but perhaps it should be there if such a patch is welcomed.

  Luis
