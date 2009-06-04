Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbZFDLOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbZFDLOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbZFDLOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:14:03 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:31777 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbZFDLOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xyFGvCm3Mbilbv4HUhVkkNx0UXzGM/+9qjg7A2kaXrGcINHqDhQk9TAsgL5sx5Fvvt
         Wh8Q/dBklpOHkZ689DMjy6FzWyU3iTvw8w3eo5HGtLke57/PYAEhct/QpDR4XpUBvIjg
         iCMlIeekbU2Bl/Dm4rfKybMsd8g3/vTFZGppQ=
MIME-Version: 1.0
In-Reply-To: <cfd18e0f0906012207i61621045je6d98db91d986c5f@mail.gmail.com>
References: <f5a7b3810905220417m5bbef733s54524e1180a9d4f7@mail.gmail.com>
	 <cfd18e0f0906012207i61621045je6d98db91d986c5f@mail.gmail.com>
Date: Thu, 4 Jun 2009 16:44:03 +0530
Message-ID: <f5a7b3810906040414me72f8b6h583ff3c05b99693@mail.gmail.com>
Subject: Re: adjtimex system man page EINVAL
From: naresh kamboju <naresh.kernel@gmail.com>
To: mtk.manpages@gmail.com
Cc: ziegler@uni-freiburg.de, akpm@linux-foundation.org, johnstul@us.ibm.com,
       zippel@linux-m68k.org, linux-kernel@vger.kernel.org,
       saji.kumar@wipro.com
Content-Type: multipart/mixed; boundary=001e680f16409f0df2046b83dfa8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001e680f16409f0df2046b83dfa8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dear Michael Kerrisk,

After comparing the changes between 2.6.25 and 2.6.29 kernels
As per my understanding EINVAL error check is removed with
timex.offset after 2.6.25 kernels and above.

To make sure the offset value following lines are added in
linux-2.6.29/kernel/time/ntp.c +80


+       /*
+        * Scale the phase adjustment and
+        * clamp to the operating range.
+        */
+       offset = min(offset, MAXPHASE);
+       offset = max(offset, -MAXPHASE);
+


I have attached patch as adjtimex_man.patch


Best wishes,
Naresh Kamboju

Signed-off-by: Naresh Kamboju < naresh.kernel@gmail.com >
diff -Naurb man-pages-3.21/man2/adjtimex.2 man-pages-3.21_mod/man2/adjtimex.2
--- man-pages-3.21/man2/adjtimex.2      2009-04-15 21:35:32.000000000 +0530
+++ man-pages-3.21_mod/man2/adjtimex.2  2009-06-04 14:19:34.000000000 +0530
@@ -118,7 +118,8 @@
 .B EINVAL
 An attempt is made to set
 .I buf.offset
-to a value outside the range \-131071 to +131071,
+to a value outside the range \-131071 to +131071 applicable upto 2.6.25
+kernels, EINVAL error check with buf.offset been removed from 2.6.25 and above,
 or to set
 .I buf.status
 to a value other than those listed above,





On Tue, Jun 2, 2009 at 10:37 AM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> Naresh,
>
> On Fri, May 22, 2009 at 1:17 PM, naresh kamboju <naresh.kernel@gmail.com> wrote:
>> Hi,
>>
>> Regarding adjtimex system man page,
>>
>> Since there are modifications noticed in
>> /kerel/time/ntp.c
>> /include/linux/timex.h
>>
>> compared with /kerel/time/ntp.c 2.6.23 and 2.6.29 and above i have
>> attached adjtimex_2.6.23_vs_2.6.29.log : line number 330.
>>
>> In adjtimex (2) man page under the EINVAL Error check section changes
>> are required w.r.t buf.offset.
>> Could you conform and update the man page.
>
> Could you please summarize in a couple of sentence what the actual
> changes are that you think are required.
>
> Cheers,
>
> Michael
>
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
> man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
> Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
>

--001e680f16409f0df2046b83dfa8
Content-Type: application/octet-stream; name="adjtimex_man.patch"
Content-Disposition: attachment; filename="adjtimex_man.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fvjdb40v0

ZGlmZiAtTmF1cmIgbWFuLXBhZ2VzLTMuMjEvbWFuMi9hZGp0aW1leC4yIG1hbi1wYWdlcy0zLjIx
X21vZC9tYW4yL2FkanRpbWV4LjIKLS0tIG1hbi1wYWdlcy0zLjIxL21hbjIvYWRqdGltZXguMgky
MDA5LTA0LTE1IDIxOjM1OjMyLjAwMDAwMDAwMCArMDUzMAorKysgbWFuLXBhZ2VzLTMuMjFfbW9k
L21hbjIvYWRqdGltZXguMgkyMDA5LTA2LTA0IDE0OjE5OjM0LjAwMDAwMDAwMCArMDUzMApAQCAt
MTE4LDcgKzExOCw4IEBACiAuQiBFSU5WQUwKIEFuIGF0dGVtcHQgaXMgbWFkZSB0byBzZXQKIC5J
IGJ1Zi5vZmZzZXQKLXRvIGEgdmFsdWUgb3V0c2lkZSB0aGUgcmFuZ2UgXC0xMzEwNzEgdG8gKzEz
MTA3MSwKK3RvIGEgdmFsdWUgb3V0c2lkZSB0aGUgcmFuZ2UgXC0xMzEwNzEgdG8gKzEzMTA3MSBh
cHBsaWNhYmxlIHVwdG8gMi42LjI1IAora2VybmVscywgRUlOVkFMIGVycm9yIGNoZWNrIHdpdGgg
YnVmLm9mZnNldCBiZWVuIHJlbW92ZWQgZnJvbSAyLjYuMjUgYW5kIGFib3ZlLAogb3IgdG8gc2V0
CiAuSSBidWYuc3RhdHVzCiB0byBhIHZhbHVlIG90aGVyIHRoYW4gdGhvc2UgbGlzdGVkIGFib3Zl
LAo=
--001e680f16409f0df2046b83dfa8--
