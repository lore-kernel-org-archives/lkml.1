Return-Path: <linux-kernel-owner+w=401wt.eu-S934414AbXEKVSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934414AbXEKVSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934253AbXEKVS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:18:26 -0400
Received: from gw.goop.org ([64.81.55.164]:48896 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934246AbXEKVSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:18:25 -0400
Message-ID: <4644DD9A.2080001@goop.org>
Date: Fri, 11 May 2007 14:18:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Ren=E9_Scharfe?= <rene.scharfe@lsrfire.ath.cx>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Arnaldo Carvalho de Melo <acme@mandriva.com>,
       Al Viro <viro@ftp.linux.org.uk>, Panagiotis Issaris <takis@issaris.org>
Subject: Re: [patch 3/7] add kstrndup
References: <20070510235708.155502000@goop.org> <20070511000027.091968000@goop.org> <4644D779.30908@lsrfire.ath.cx>
In-Reply-To: <4644D779.30908@lsrfire.ath.cx>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

René Scharfe wrote:
>> +	len = strlen(s);
>> +	if (len > max)
>> +		len = max;
>>     
>
> You can avoid to run beyond max and save two lines by using strnlen:
>
> 	len = strnlen(s, max);
>   

OK.  Didn't know about strnlen.

Subject: Use strnlen in kstrndup

strnlen prevents over-reading the input.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: René Scharfe <rene.scharfe@lsrfire.ath.cx>

---
 mm/util.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

===================================================================
--- a/mm/util.c
+++ b/mm/util.c
@@ -53,9 +53,7 @@ char *kstrndup(const char *s, size_t max
 	if (!s)
 		return NULL;
 
-	len = strlen(s);
-	if (len > max)
-		len = max;
+	len = strnlen(s, max);
 	buf = kmalloc_track_caller(len+1, gfp);
  	if (buf) {
 		memcpy(buf, s, len);


