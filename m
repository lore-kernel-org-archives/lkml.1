Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYDSEKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYDSEKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 00:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYDSEKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 00:10:35 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54613 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbYDSEKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 00:10:34 -0400
X-Sasl-enc: mfCT/NCofYWWfdwVN3XcwjPd+mkAKDY6xXzAILwAZiAo 1208578232
Date: Sat, 19 Apr 2008 01:10:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, bfields@fieldses.org, neilb@suse.de,
       len.brown@intel.com, kkeil@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] ThinkPad ACPI: fix possible NULL pointer
	dereference
Message-ID: <20080419041029.GB11635@khazad-dum.debian.net>
References: <20080416174421.442716301@gmail.com>> <48063bc9.2533440a.1932.1fc1@mx.google.com> <20080418124111.GB4966@ucw.cz> <20080418130719.GB7674@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418130719.GB7674@cvg>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008, Cyrill Gorcunov wrote:
> Oh, I see what do you mean - you mean that even if machine is ThinkPad
> *but* kstrdup failed with my patch it would lead that the machine will
> *not* be recognized as ThinkPad and that is not correct, agreed. But how

That's acceptable.  It is not worth bothering with this failure mode at
that point of the driver lifetime.  Your patch makes it just keep
running, which is fine since if it can't kstrdup a small string, it will
abend with -ENOMEM soon enough when it tries to alocate other much
bigger structures.

Just in case, I will schedule a low-priority fix for later that will
-ENOMEM if kstrdup fails, but your patch is good enough a fix for now.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
