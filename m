Return-Path: <linux-kernel-owner+w=401wt.eu-S1762499AbXHKU6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762499AbXHKU6n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 16:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbXHKU6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 16:58:34 -0400
Received: from smtp114.sbc.mail.re2.yahoo.com ([68.142.229.91]:33131 "HELO
	smtp114.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752025AbXHKU6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 16:58:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=O0WFX9IFOMvbSrlyTIKllBk2VDsWtgtJjWDUusBPqVvY80cdfLKRBsyaYfoQVBX1PtdpbBxR1FDr6DJH7M+LXsAc/8SOTEDb4CFC7wO0iB5nq5T8COuqLeNgbbYe10rA/d5WC+lecOI5eMEx6zcK5xrDWDiEKoxe9rCxWuqVVKo=  ;
X-YMail-OSG: D8WFxVIVM1kK4X24.gDZqyZXq3q.d6dwVG8UrX69o744kCRiJXBd4wRJrrPXEHSpbqMyY05cD2Jh1k7d.0hzPiHZXSGiWuPStYhkrLjQFwLqzcIDMtR5IFKflhHRjt1H59AogKc1KI_3gVQ-
From: David Brownell <david-b@pacbell.net>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] 2.6.23-rc2-mm2
Date: Sat, 11 Aug 2007 13:58:30 -0700
User-Agent: KMail/1.9.6
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <20070809224254.11f42716.akpm@linux-foundation.org> <46BC3CB1.2090503@googlemail.com> <46BC5D18.9060906@googlemail.com>
In-Reply-To: <46BC5D18.9060906@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708111358.30667.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 August 2007, Gabriel C wrote:
> Getting that with gcc 4.2.1 :
>
> drivers/usb/host/ohci-dbg.c: In function 'show_registers':
> drivers/usb/host/ohci-dbg.c:620: warning: the address of 'next' will always evaluate as 'true'
> drivers/usb/host/ohci-dbg.c:639: warning: the address of 'next' will always evaluate as 'true'

Seems like a pretty annoying warning to have added ... the relevant
test *expects* to have two constant branches, where the compiler
optimizes one out of existence.

Does this patch get rid of it?

---
 drivers/usb/host/ohci-dbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- g26.orig/drivers/usb/host/ohci-dbg.c	2007-08-11 13:51:42.000000000 -0700
+++ g26/drivers/usb/host/ohci-dbg.c	2007-08-11 13:52:07.000000000 -0700
@@ -74,7 +74,7 @@ urb_print (struct urb * urb, char * str,
 
 #define ohci_dbg_sw(ohci, next, size, format, arg...) \
 	do { \
-	if (next) { \
+	if (next != NULL) { \
 		unsigned s_len; \
 		s_len = scnprintf (*next, *size, format, ## arg ); \
 		*size -= s_len; *next += s_len; \
