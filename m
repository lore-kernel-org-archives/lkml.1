Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZFTUpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZFTUpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 16:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZFTUpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 16:45:32 -0400
Received: from mail-fx0-f214.google.com ([209.85.220.214]:51666 "EHLO
	mail-fx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbZFTUpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 16:45:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=c9B/q6DFEUCkLrXIDmiH8JIgYhiu7hGjVbHQ/Vh4jjG21+jqkr3n9pa6K+VhEcu0pz
         ycI2ocnyXeLyMcFOFNypB0bMeLixkXXrnrKtY1RUAT64107shmpEcPk/OJ+bFYgAD+NM
         F6tKjNl2wZWPeplLYi1ZjSBtfETD6mz27+eBk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Dan Aloni <dan@aloni.org>
Subject: Re: [PATCH] Staging: prevent rtl8187se from crashing dev_ioctl() in SIOCGIWNAME
Date: Sat, 20 Jun 2009 22:51:16 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <20090620133222.GA18731@localhost>
In-Reply-To: <20090620133222.GA18731@localhost>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906202251.16916.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 June 2009 15:32:22 Dan Aloni wrote:
> I repeatedly get __stack_chk_fail panic()s with this driver before
> applying the attached fix.
> 
> ieee80211_wx_get_name() ignores sizeof(wrqu->name) which is IFNAMSIZ (16), and
> on certain conditions, the concatenated string will be larger than IFNAMSIZ
> including the terminating zero.
> 
>     length ("802.11" ++ "b" ++ "/g" ++ " linked" ++ "\x00") == 17
> 
> This fix uses strl{cpy,cat} in addition to the reduction of the total
> possible length of the output string by a char.
> 
> It can be applied to 2.6.30-stable as well.

Recently added rtl8192su driver seems to also need it, care to port the fix?
(http://patchwork.kernel.org/patch/29630/ is needed to build rtl8192su ATM)
