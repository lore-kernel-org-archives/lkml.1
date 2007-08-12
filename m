Return-Path: <linux-kernel-owner+w=401wt.eu-S933389AbXHLKRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbXHLKRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbXHLKRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:17:30 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:22266 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbXHLKR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:17:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=N6WAF2MMVXJ3Ankbmc9lVomUBOaIc36xTupi+A593j4seqRWDFW1YGt/ynVLtLJZYzgoSCPSGUqzmA/bBUyT52Jb03fbAihx/GV5J81A+q36dUHqpm1Ka9g0ZsrXSatHAhuF7mBp6gsho+danbPDzRT/nfy3K86X3bhSt5nI6B0=
Message-ID: <46BEDDB2.4080704@googlemail.com>
Date: Sun, 12 Aug 2007 12:15:14 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: linux-usb-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] 2.6.23-rc2-mm2
References: <20070809224254.11f42716.akpm@linux-foundation.org> <46BC3CB1.2090503@googlemail.com> <46BC5D18.9060906@googlemail.com> <200708111358.30667.david-b@pacbell.net>
In-Reply-To: <200708111358.30667.david-b@pacbell.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Friday 10 August 2007, Gabriel C wrote:
>> Getting that with gcc 4.2.1 :
>>
>> drivers/usb/host/ohci-dbg.c: In function 'show_registers':
>> drivers/usb/host/ohci-dbg.c:620: warning: the address of 'next' will always evaluate as 'true'
>> drivers/usb/host/ohci-dbg.c:639: warning: the address of 'next' will always evaluate as 'true'
> 
> Seems like a pretty annoying warning to have added ... the relevant
> test *expects* to have two constant branches, where the compiler
> optimizes one out of existence.
> 
> Does this patch get rid of it?
> 

Yes it does.


> ---
>  drivers/usb/host/ohci-dbg.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- g26.orig/drivers/usb/host/ohci-dbg.c	2007-08-11 13:51:42.000000000 -0700
> +++ g26/drivers/usb/host/ohci-dbg.c	2007-08-11 13:52:07.000000000 -0700
> @@ -74,7 +74,7 @@ urb_print (struct urb * urb, char * str,
>  
>  #define ohci_dbg_sw(ohci, next, size, format, arg...) \
>  	do { \
> -	if (next) { \
> +	if (next != NULL) { \
>  		unsigned s_len; \
>  		s_len = scnprintf (*next, *size, format, ## arg ); \
>  		*size -= s_len; *next += s_len; \
> 
