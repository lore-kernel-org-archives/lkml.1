Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab0CCGAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:00:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39916 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab0CCGAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:00:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=Lc+xRrypZYJm1PqV7cn6CVDM1Zzxv53wwlBWto0aTxty4LQJgv+3vY6Y3XXWblHAuS
         PjKMgH2R98gqkT+ctA86zBanjGBmoi+G2QcPDcTeBGsgMVtGEnwShdJvp7twd1R9Hyeo
         Z2jhFg/pXblwMgFm8VPlpIZXWeFc6yfsTyBXg=
MIME-Version: 1.0
In-Reply-To: <20100303045624.GB10185@linux.vnet.ibm.com>
References: <f5a7b3811002250545x3d5288cfqd114d3bcd79581f2@mail.gmail.com>
	 <20100302085046.GA27023@linux.vnet.ibm.com>
	 <f5a7b3811003020708wdd0710fv4c3e1dcf1992935c@mail.gmail.com>
	 <20100303045624.GB10185@linux.vnet.ibm.com>
Date: Wed, 3 Mar 2010 11:30:42 +0530
Message-ID: <f5a7b3811003022200r32a0e108g8eaf5d9a2ce66b4a@mail.gmail.com>
Subject: Re: [LTP] [PATCH] Synchronization required before release the lock: 
	sem_post/8-1.c
From: naresh kamboju <naresh.kernel@gmail.com>
To: Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
Content-Type: multipart/mixed; boundary=000e0cd1a868d198710480df337a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd1a868d198710480df337a
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Mar 3, 2010 at 10:26 AM, Rishikesh K Rajak
<risrajak@linux.vnet.ibm.com> wrote:
> On Tue, Mar 02, 2010 at 08:38:20PM +0530, naresh kamboju wrote:
>> On Tue, Mar 2, 2010 at 2:20 PM, Rishikesh K Rajak
>> <risrajak@linux.vnet.ibm.com> wrote:
>> > I feel before getting semaphore value, we need to sync first so here
>> > sleep is require,though your point is valid that there is no use of
>> > using sleep inside while loop.
>> I agree with you.
>> AFAIU, we should call sleep() before calling getting semaphore
>> value.when we don't have while loop here. Because while loop condition
>> is depends on val so when ever we call sem_getvalue() it will get
>> latest value of val.
>> In addition to this, we are ensuring val is decremented before we do
>> unlock the sem by while loop condition.
>>
>> Having sleep() in while loop will not effect the final output. IIUC
>>
>
> Hi Naresh,
>
> I am not able to apply your patch against ltp next branch. can you
> please send me patch against next branch of ltp ?
Here I have posted and attached to this e-mail.

Signed-off-by: Naresh Kamboju < naresh.kernel@gmail.com >

---
 testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
|   15 	8 +	7 -	0 !
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: b/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
===================================================================
--- a/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
+++ b/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
@@ -161,7 +161,6 @@ int main()
 	}
 	fprintf(stderr, "P: child_1:%d forked\n", c_1);
 	
-	sleep(1);
 	c_2 = fork();
 	if (c_2 == 0)
 	{
@@ -176,13 +175,13 @@ int main()
 	}
 	fprintf(stderr, "P: child_2: %d forked\n", c_2);

+        /* Step 3 Implementation */
 	/* Make sure the two children has been waiting */	
-	/*do {
-		sleep(1);
+	do {
 		sem_getvalue(sem_1, &val);
 		//printf("val = %d\n", val);
 	} while (val != 1);
-	*/
+
 	c_3 = fork();
 	if (c_3 == 0)
 	{
@@ -191,13 +190,15 @@ int main()
 	}
 	fprintf(stderr, "P: child_3: %d forked\n", c_3);
 	
+        /* Step 3 Implementation */
 	/* Make sure child 3 has been waiting for the lock */	
-	/*do {
-		sleep(1);
+	do {
 		sem_getvalue(sem_1, &val);
 		//printf("val = %d\n", val);
 	} while (val != 0);
-	*/
+
+	/* Synchronization required before release the lock */
+	sleep(1);
 	/* Ok, let's release the lock */
 	fprintf(stderr, "P: release lock\n");
 	sem_post(sem);

Best regards
Naresh Kamboju
>
> #git clone -b next
> git://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev.git ltp
>
> And then create your patch and send it to ltp-list@
>
> --
> Thanks & Regards
> Rishi
> LTP Maintainer
> IBM, LTC, Bangalore
> Please join IRC #ltp @ irc.freenode.net
>

--000e0cd1a868d198710480df337a
Content-Type: application/octet-stream; 
	name="posix-sem-post-unstable-fix.patch"
Content-Disposition: attachment; 
	filename="posix-sem-post-unstable-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g6bpxm9m0

LS0tCiB0ZXN0Y2FzZXMvb3Blbl9wb3NpeF90ZXN0c3VpdGUvY29uZm9ybWFuY2UvaW50ZXJmYWNl
cy9zZW1fcG9zdC84LTEuYyB8ICAgMTUgCTggKwk3IC0JMCAhCiAxIGZpbGUgY2hhbmdlZCwgOCBp
bnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKSW5kZXg6IGIvdGVzdGNhc2VzL29wZW5fcG9z
aXhfdGVzdHN1aXRlL2NvbmZvcm1hbmNlL2ludGVyZmFjZXMvc2VtX3Bvc3QvOC0xLmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gYS90ZXN0Y2FzZXMvb3Blbl9wb3NpeF90ZXN0c3VpdGUvY29uZm9ybWFuY2UvaW50
ZXJmYWNlcy9zZW1fcG9zdC84LTEuYworKysgYi90ZXN0Y2FzZXMvb3Blbl9wb3NpeF90ZXN0c3Vp
dGUvY29uZm9ybWFuY2UvaW50ZXJmYWNlcy9zZW1fcG9zdC84LTEuYwpAQCAtMTYxLDcgKzE2MSw2
IEBAIGludCBtYWluKCkgCiAJfQogCWZwcmludGYoc3RkZXJyLCAiUDogY2hpbGRfMTolZCBmb3Jr
ZWRcbiIsIGNfMSk7CiAJCi0Jc2xlZXAoMSk7CiAJY18yID0gZm9yaygpOwogCWlmIChjXzIgPT0g
MCkKIAl7CkBAIC0xNzYsMTMgKzE3NSwxMyBAQCBpbnQgbWFpbigpIAogCX0KIAlmcHJpbnRmKHN0
ZGVyciwgIlA6IGNoaWxkXzI6ICVkIGZvcmtlZFxuIiwgY18yKTsKIAorICAgICAgICAvKiBTdGVw
IDMgSW1wbGVtZW50YXRpb24gKi8KIAkvKiBNYWtlIHN1cmUgdGhlIHR3byBjaGlsZHJlbiBoYXMg
YmVlbiB3YWl0aW5nICovCQotCS8qZG8geyAKLQkJc2xlZXAoMSk7CisJZG8gewogCQlzZW1fZ2V0
dmFsdWUoc2VtXzEsICZ2YWwpOwogCQkvL3ByaW50ZigidmFsID0gJWRcbiIsIHZhbCk7CiAJfSB3
aGlsZSAodmFsICE9IDEpOwotCSovCisKIAljXzMgPSBmb3JrKCk7CiAJaWYgKGNfMyA9PSAwKQog
CXsKQEAgLTE5MSwxMyArMTkwLDE1IEBAIGludCBtYWluKCkgCiAJfQogCWZwcmludGYoc3RkZXJy
LCAiUDogY2hpbGRfMzogJWQgZm9ya2VkXG4iLCBjXzMpOwogCQorICAgICAgICAvKiBTdGVwIDMg
SW1wbGVtZW50YXRpb24gKi8KIAkvKiBNYWtlIHN1cmUgY2hpbGQgMyBoYXMgYmVlbiB3YWl0aW5n
IGZvciB0aGUgbG9jayAqLwkKLQkvKmRvIHsgCi0JCXNsZWVwKDEpOworCWRvIHsKIAkJc2VtX2dl
dHZhbHVlKHNlbV8xLCAmdmFsKTsKIAkJLy9wcmludGYoInZhbCA9ICVkXG4iLCB2YWwpOwogCX0g
d2hpbGUgKHZhbCAhPSAwKTsKLQkqLworCisJLyogU3luY2hyb25pemF0aW9uIHJlcXVpcmVkIGJl
Zm9yZSByZWxlYXNlIHRoZSBsb2NrICovCisJc2xlZXAoMSk7CiAJLyogT2ssIGxldCdzIHJlbGVh
c2UgdGhlIGxvY2sgKi8KIAlmcHJpbnRmKHN0ZGVyciwgIlA6IHJlbGVhc2UgbG9ja1xuIik7CiAJ
c2VtX3Bvc3Qoc2VtKTsK
--000e0cd1a868d198710480df337a--
