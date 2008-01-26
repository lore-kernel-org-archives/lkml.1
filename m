Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbYAZOje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbYAZOje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 09:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbYAZOjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 09:39:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:9059 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYAZOjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 09:39:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nG1V1S/qP89O9TLM6Xe4xpELhDD8nEgw3v3IKmUdc9YPpZ22T+xiFxuQCK2yjQgkTRMNx5oxhts2m6oBhbnoNnLgJwv8OnnkcZ6Blwta5SRcQYmEBtcg2I8DJR8oHvo30KXZh58m47bhimYMfCZS70id10gIcYBhtsK8mMg140U=
Message-ID: <f284c33d0801260639j6d41537qebee033ed7b46aa8@mail.gmail.com>
Date: Sat, 26 Jan 2008 21:39:20 +0700
From: "Mulyadi Santosa" <mulyadi.santosa@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: updating the explanation of "profile=" param
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mulyadi Santosa

Fixing "profile" kernel parameter:
- adding "kvm" parameter description
- a bit more verbose explanation of "schedule"/"sleep" param
- explicitly tells that CPU profiling is the default mode
  if none is mentioned.

Done against vanilla 2.6.23.13

PS: I am not subscribed to linux-kernel@vger, so please kindly Cc:
your reply to my e-mail address.

Signed-off-by: Mulyadi Santosa <mulyadi.santosa@gmail.com>
---

 Documentation/kernel-parameters.txt |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)


--- linux-2.6.23.13/Documentation/kernel-parameters.txt.bak	2008-01-10
00:18:17.000000000 +0700
+++ linux-2.6.23.13/Documentation/kernel-parameters.txt	2008-01-25
22:49:37.000000000 +0700
@@ -1391,12 +1391,19 @@ and is between 256 and 4096 characters.
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)

 	profile=	[KNL] Enable kernel profiling via /proc/profile
-			Format: [schedule,]<number>
-			Param: "schedule" - profile schedule points.
-			Param: <number> - step/bucket size as a power of 2 for
-				statistical time based profiling.
-			Param: "sleep" - profile D-state sleeping (millisecs)
-
+			Format: [schedule/sleep/kvm,]<number>
+			First param is one of these (they can't be combined!):
+			Param: "schedule" - profile schedule() call.
+			Param: "sleep" - profile where a task sleeps (millisecs).
+			Param: "kvm" - profile KVM exit call.
+
+			If first param is omitted then cpu profiling mode
+			is effectively applied. In this mode, profiling is
+			done in tick handler.
+
+			Second param: <number> - step/bucket size as a power
+			of 2 for statistical time based profiling.
+	
 	processor.max_cstate=	[HW,ACPI]
 			Limit processor to maximum C-state
 			max_cstate=9 overrides any DMI blacklist limit.
